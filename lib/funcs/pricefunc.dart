// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jazia/screens/register.dart';

class GetPrice extends StatefulWidget {
  int wig_price;
  GetPrice({Key? key, required this.wig_price}) : super(key: key);

  @override
  _GetPriceState createState() => _GetPriceState();
}

class _GetPriceState extends State<GetPrice> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
final User? _user = FirebaseAuth.instance.currentUser;
  ///UPLOAD THE ITEM TO DB
  ///
bool userHasAccount(){
  bool hasAccount = false;
 var check = firestore.collection('users').doc(_user!.uid).get();
check.then((value) {
  hasAccount = (value.data()!=null);
if (kDebugMode) {
  print(hasAccount);
}
});
return hasAccount;
}
@override
  void initState() {
    userHasAccount();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CupertinoAlertDialog(
      title: const Text('Marked Price:'),
      content: Text(widget.wig_price.toString()),
      actions: <Widget>[
        TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(CupertinoIcons.chat_bubble_text),
                Text('Make Offer'),
              ],
            )),
        TextButton(
            onPressed: () {
             
            userHasAccount()? showDialog(context: context, builder: (context){
              return CupertinoAlertDialog(
                title: Text('hello'),
              );
            }): Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegisterForm()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Jazia'),
                Icon(CupertinoIcons.money_euro_circle),
              ],
            )),
      ],
    );
  }
}
