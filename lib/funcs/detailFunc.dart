import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';

class GetDetail extends StatefulWidget {
  String wig_detail, wig_name;
  GetDetail({Key? key, required this.wig_detail, required this.wig_name})
      : super(key: key);

  @override
  _GetDetailState createState() => _GetDetailState();
}

class _GetDetailState extends State<GetDetail> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///UPLOAD THE ITEM TO DB
  ///

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CupertinoAlertDialog(
      title: Text(widget.wig_name.toString()),
      content: Text(widget.wig_detail.toString()),
      actions: <Widget>[
        TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(CupertinoIcons.question_circle),
                Text('Is it Available'),
              ],
            )),
        TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('0722494071'),
                Icon(CupertinoIcons.phone),
              ],
            )),
      ],
    );
  }
}
