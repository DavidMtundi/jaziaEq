import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';


class GetPrice extends StatefulWidget {
  int wig_price;
  GetPrice({Key? key, required this.wig_price}) : super(key: key);

  @override
  _GetPriceState createState() => _GetPriceState();
}

class _GetPriceState extends State<GetPrice> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  ///UPLOAD THE ITEM TO DB
  ///


  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return CupertinoAlertDialog(
      title: const Text('Marked Price:'),
      content: Text(widget.wig_price.toString()),
      actions: <Widget>[
        TextButton(onPressed: (){}, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(CupertinoIcons.chat_bubble_text),
            Text('Make Offer'),
          ],
        )),
        TextButton(onPressed: (){}, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Jazia'),
            Icon(CupertinoIcons.money_euro_circle),
          ],
        )),
      ],
    );
  }
}
