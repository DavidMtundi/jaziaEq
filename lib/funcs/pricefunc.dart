// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jazia/screens/jaziaquery.dart';
import 'package:jazia/screens/jaziaquerysave.dart';
import 'package:jazia/screens/register.dart';

import '../screens/registernew.dart';

class GetPrice extends StatefulWidget {
  int wig_price;
  String wig_name, wig_url, wig_des, wig_contact;
  GetPrice({Key? key, required this.wig_des, required this.wig_contact,required this.wig_price, required this.wig_name, required this.wig_url}) : super(key: key);

  @override
  _GetPriceState createState() => _GetPriceState();
}

class _GetPriceState extends State<GetPrice> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
final User? _user = FirebaseAuth.instance.currentUser;
  ///UPLOAD THE ITEM TO DB
  ///
/*bool userHasAccount(){
  bool hasAccount = false;
 var check = firestore.collection('users').doc(_user!.uid).get();
check.then((value) {
  hasAccount = (value.data()!=null);
if (kDebugMode) {
  print(hasAccount);
}
});
return hasAccount;
}*/
@override
  void initState() {
    //userHasAccount();
    super.initState();
  }

  Future navigateLink(BuildContext ctx)async{

  Navigator.pop(ctx);

  }
bool clickSave = false;
bool clickBorrow = false;
  Future<void> checkLinkedSave() async{
  firestore.collection('users').doc(_auth.currentUser!.uid).get().then((value) {
    var see = value.data()!.containsKey('linked');
    print(see);
    setState(() {
      clickSave == false;
    });
    if(see == false){
      _showSave(context);
    }
    else if(see ==true){
      Navigator.of(context).pop();
      showDialog(context: context, builder: (context){
        return JaziaQuerySave(wig_name: widget.wig_name, wig_price: widget.wig_price, wig_url: widget.wig_url, wig_des: widget.wig_des, wig_contact: widget.wig_contact,);
      });
    }
  });

  }

  Future<void> checkLinkedBorrow() async{
    firestore.collection('users').doc(_auth.currentUser!.uid).get().then((value) {
      var see = value.data()!.containsKey('linked');
      print(see);
      if(see == false){
        _show(context);
      }
      else if(see ==true){
        Navigator.of(context).pop();
        showDialog(context: context, builder: (context){
          return JaziaQuery();
        });
      }
    });

  }

  void _showSave(BuildContext ctx) async{
    await showCupertinoModalPopup(
        context: ctx,
        builder: (_) => CupertinoActionSheet(
          title: Text('Save for an item with Jazia'),
          message: Text('Link to a savings bank account and save for this item \n (This will take less than a minute)'),
          actions: [
            CupertinoActionSheetAction(
                onPressed: () => {
                  navigateLink(ctx).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterForm())),
                  ),
                  _close(ctx)
                },
                child: const Text('Link Jazia to Bank Account')),
            CupertinoActionSheetAction(
              // isDefaultAction: true,
                onPressed: () => {
                  navigateLink(ctx).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterNewForm())),
                  )
                },
                child: const Text('Create a Bank Account')),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => _close(ctx),
            child: const Text('Close'),
            isDefaultAction: true,
          ),
        ));
  }
  void _show(BuildContext ctx) async{
     await showCupertinoModalPopup(
        context: ctx,
        builder: (_) => CupertinoActionSheet(
          title: Text('Borrow from Jazia'),
          message: Text('Link to a bank account that will be funded \n (This will take less than a minute)'),
          actions: [
            CupertinoActionSheetAction(
                onPressed: () => {
                  navigateLink(ctx).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterForm())),
                  ),
                  _close(ctx)
                },
                child: const Text('Link Jazia to Bank Account')),
            CupertinoActionSheetAction(
             // isDefaultAction: true,
                onPressed: () => {
                  navigateLink(ctx).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterNewForm())),
                  )
                  },
                child: const Text('Create a Bank Account')),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => _close(ctx),
            child: const Text('Close'),
            isDefaultAction: true,
          ),
        ));
  }

  // This function is used to close the action sheet
  void _close(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CupertinoAlertDialog(
      title: const Text('Marked Price:'),
      content: Text(widget.wig_price.toString()),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              //_showSave(context);
              setState(() {
                clickSave ==true;
              });
              checkLinkedSave();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                clickSave?CupertinoActivityIndicator():Icon(CupertinoIcons.chat_bubble_text),
                Text('Jazia save'),
              ],
            )),
        TextButton(
            onPressed: () {
              //_show(context);
              checkLinkedBorrow();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Jazia borrow'),
                Icon(CupertinoIcons.money_dollar_circle),
              ],
            )),
      ],
    );
  }
}
