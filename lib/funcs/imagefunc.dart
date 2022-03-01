import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';


class GetImage extends StatefulWidget {
  String wig_url;
   GetImage({Key? key, required this.wig_url}) : super(key: key);

  @override
  _GetImageState createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  ///UPLOAD THE ITEM TO DB
  ///


  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return CupertinoAlertDialog(
     // title: const Text('Pick an Image'),
      content: Image.network(widget.wig_url,),
      actions: <Widget>[
        TextButton(onPressed: (){}, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(CupertinoIcons.arrowshape_turn_up_left),
            Text('Previous'),
          ],
        )),
        TextButton(onPressed: (){}, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Next'),
            Icon(CupertinoIcons.arrowshape_turn_up_right),
          ],
        )),
      ],
    );
  }
}
