// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jazia/Smsfunctions/GetMessages.dart';
import 'package:jazia/auth/auth.dart';

ValueNotifier<Map<String, dynamic>> data = ValueNotifier({});

class TestLoan extends StatefulWidget {
  const TestLoan({Key? key}) : super(key: key);

  @override
  State<TestLoan> createState() => _TestLoanState();
}

class _TestLoanState extends State<TestLoan> {

User? user = FirebaseAuth.instance.currentUser;
FirebaseFirestore firestore = FirebaseFirestore.instance;
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

Future createKey()async{
    Uri url = Uri(
      scheme: 'http',
      host: '9b08-41-89-229-17.ngrok.io',
      path: '/createKey',
      queryParameters: {
        'id': user!.uid//convert(stringToBase64.encode(user!.uid)),
      });
      try {
      http.post(url).then((response) {
        print(jsonDecode(response.body.trim()));
      });
      } catch (e) {
        print(e);
      }
}
 Future getKey()async{
    String key ='';
    await firestore.collection('users').doc(user!.uid).get().then((value) {
      key = value['key'];
    });
    return key;
  }

  
  getData({amount,period}) async {
    Uri url = Uri(
      scheme: 'http',
      host: '9b08-41-89-229-17.ngrok.io',
      path: '/simulateloan',
      queryParameters: {
        'docId': user!.uid,//convert(stringToBase64.encode(user!.uid)),
        'key': getKey(),
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
 
requestLoan(amount,period){
  createKey().then((_) =>getKey().then((_) => getData(amount: amount,period: period)));
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
  @override
  void initState() {
   getsms();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {



return Scaffold(
appBar: AppBar(leading: IconButton(icon: Icon(Icons.dangerous),onPressed: (){
  CheckRegex().getsms();
},),),
body: SingleChildScrollView(
  child:   Column(
  
    children: sms.map((e) => ListTile(title:Text(CheckRegex().getAmount(e.body.toString()).toString()))).toList(),
  
  ),
),
);







    // return ValueListenableBuilder(
    //     valueListenable: data,
    //     builder: (context, value, child) {
    //       return Scaffold(
    //         appBar: AppBar(
    //           actions: [IconButton(onPressed: (){
    //             AuthService().signOut();
    //           }, icon: Icon(Icons.exit_to_app))],
    //         ),
    //         body: Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               data.value.isNotEmpty
    //                   ? Padding(
    //                       padding: const EdgeInsets.all(20.0),
    //                       child: Text(
    //                         (data.value['accepted']
    //                             ? data.value['loanMessage'].toString()
    //                             : data.value['info'].toString() +
    //                                 '\n' +
    //                                 'date due: ' +
    //                                 data.value['dateDue'].toString() +
    //                                 '\n' +
    //                                 'interest rate: ' +
    //                                 data.value['interestRate'].toString() +'%' +
    //                                 '\n' +
    //                                 'amount payable ' +
    //                                 data.value['amountPayable'].toString()),
    //                         textAlign: TextAlign.center,
    //                         style: GoogleFonts.aBeeZee(fontSize: 18),
    //                       ),
    //                     )
    //                   : !isLoading
    //                       ? SizedBox()
    //                       : CupertinoActivityIndicator(),
    //               TextButton(
    //                   onPressed: () {
    //                    // print(convert('Hello'));
    //                    //print(stringToBase64.encode(mike));
    //                     setState(() {
    //                       isLoading = true;
    //                     });
    //                    requestLoan(1000, 6);
    //                   },
    //                   child: Text('check loan limit'))
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }
}
