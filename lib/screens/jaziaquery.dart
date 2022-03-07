import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jazia/chatfiles/chatpage.dart';
import 'package:jazia/screens/myBorrow.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../Smsfunctions/GetMessages.dart';

TextStyle _style = GoogleFonts.varelaRound();

class JaziaQuery extends StatefulWidget {

  JaziaQuery({Key? key, }) : super(key: key);


  @override
  _JaziaQueryState createState() => _JaziaQueryState();
}

class _JaziaQueryState extends State<JaziaQuery> {
  ValueNotifier<Map<String, dynamic>> data = ValueNotifier({});
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController amountController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;


  User? user = FirebaseAuth.instance.currentUser;
  Codec stringToBase64 = utf8.fuse(base64);

  String convert(String userid) {
    String newString = "";

    List chars =userid.split('');
    List newChars =[];
    for (String char in chars) {
      newChars.add(char.toUpperCase()==char?char.toLowerCase():char.toUpperCase());
    }
    newString =newChars.reversed.join('');
    return newString;
  }
  requestLoan(amount,period){
 //createKey().then((res) {
     // print(res);
    //  if(res.isNotEmpty){
        getKey().then((c) {
          if(c.isNotEmpty){
            print(c);
          getData(amount: amount,period: period,key: c);
          }
        });
    //  }

 //});
  }
  bool isLoading = false;
  List<SmsMessage> sms =[];
  getsms()async{
    await CheckRegex().getallMessages().then((_)async {
      setState(() {
        sms =  CheckRegex().getextractedmessages();
      });

    });
  }

  Future <Map> createKey()async{
    Map<String,dynamic> res ={};
    Uri url = Uri(
        scheme: 'http',
        host: '9da7-41-89-229-17.ngrok.io',
        path: '/createKey',
        queryParameters: {
          'id': user!.uid//convert(stringToBase64.encode(user!.uid)),
        });
    try {
      http.post(url).then((response) {
        //print(jsonDecode(response.body.trim()));
        res =jsonDecode(response.body.trim());

      });
    } catch (e) {
      print(e);
    }
    return res;
  }
  Future <String> getKey()async{
    String key ='';
    await firestore.collection('users').doc(user!.uid).get().then((value) {
      key = value['key'];
    });
    return key;
  }


  getData({amount,period,key}) async {
    Uri url = Uri(
        scheme: 'http',
        host: '9da7-41-89-229-17.ngrok.io',
        path: '/simulateloan',
        queryParameters: {
          'docId': user!.uid,//convert(stringToBase64.encode(user!.uid)),
          'key': key,//"Pw~Ifo7o{zlC^pJD5XSQpu[w8J#p2tNR)LwWxzDq",//getKey(),
          'amount': amount.toString(),
          'period': period.toString()
        });
    try {
      var res = await http.get(
        url,
      );
      if (res.statusCode == 200) {
        setState(() {});
        data = ValueNotifier(jsonDecode(res.body.trim()));
        print(jsonDecode(res.body.trim()));
        isLoading = false;
      } else {
        setState(() {});
        isLoading = false;
        data = ValueNotifier(jsonDecode(res.body.trim()));
        print(jsonDecode(res.body.trim()));
      }
    } catch (e) {
      print(e);
    }
  }


  int? dropdownvalue = 1;
  var items = [
    1,2,3,4,5,6,7,8,9,10,11,12,
  ];
  ///UPLOAD THE ITEM TO DB
  ///

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CupertinoAlertDialog(
      title:  Text(data.value.isNotEmpty?'':'How much you need?'),
      content: Material(
       // color: data.value.isNotEmpty?Theme.of(context).brightness == Brightness.dark?Colors.black:Colors.white:Colors.transparent,
color: Colors.transparent,
        child:
        // isLoading? Center(child: CupertinoActivityIndicator(),):Center(
        //   child:data.value.isNotEmpty?  Column(
        //     children: [
        //       Text(!data.value['accepted']?data.value['info']:data.value['message'])
        //     ],
        //   ):Container(),
        // ),
       isLoading?Center(child: CupertinoActivityIndicator(),): Column(
         ///TODO: PANGA HAPA
          children:data.value.isNotEmpty?[
               Text(!data.value['accepted']?data.value['info']:data.value['loanMessage']),
              Text(!data.value['accepted']?'date due: ${data.value['dateDue']}':''),
            Text(!data.value['accepted']?'amount payable: ${data.value['amountPayable']}':'')
              //  Text(!data.value['accepted']?"date due: ${data.value['dateDue']":''),
          ] :[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: amountController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'amount is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).brightness ==
                        Brightness.light
                        ? Colors.blue.withOpacity(.1)
                        : Colors.red.withOpacity(.1),
                    filled: true,
                    labelText: 'Enter amount',
                    labelStyle: _style.copyWith(fontSize: 12),

                    // border: OutlineInputBorder(
                    //     borderRadius:
                    //         BorderRadius.circular(10))
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Select Payment Period \n(Months):'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: DropdownButton(
                  value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((int items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items.toString()),
                      );
                    }).toList(),
                  onChanged: (int? newValue) async {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                   },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        isLoading? CupertinoActivityIndicator.partiallyRevealed():  TextButton(
            onPressed: () async{
             if(data.value.isNotEmpty){
                    setState(() {
                      isLoading = true;
                    });
                    requestLoan(amountController.text, dropdownvalue);
                  } else {
               Navigator.of(context).pop;
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => MyBorrow()),
               );
             }
                },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                Text('Proceed'),
                Icon(CupertinoIcons.arrow_right),
              ],
            )
        ),
      ],
    );
  }
}
