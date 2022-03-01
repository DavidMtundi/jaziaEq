import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';


class GetName extends StatefulWidget {
  String wig_name;
  GetName({Key? key, required this.wig_name}) : super(key: key);

  @override
  _GetNameState createState() => _GetNameState();
}

class _GetNameState extends State<GetName> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  ///UPLOAD THE ITEM TO DB
  ///


  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return CupertinoAlertDialog(
      title:  Text(widget.wig_name.toString()),
      content: Text('Condition: Brandnew'),
      actions: <Widget>[
        TextButton(onPressed: (){}, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(CupertinoIcons.question_circle),
            Text('Is it Available'),
          ],
        )),
        TextButton(onPressed: (){}, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('0722494071'),
            Icon(CupertinoIcons.phone),
          ],
        )),
      ],
    );
  }
}
