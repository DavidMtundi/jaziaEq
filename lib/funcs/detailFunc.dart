import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class GetDetail extends StatefulWidget {
  String wig_detail, wig_name, wig_contact;
  GetDetail({Key? key, required this.wig_detail, required this.wig_name, required this.wig_contact})
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
            onPressed: () async{
              //Navigator.of(context).pop();
              const url = 'https://google.com';
              if(await canLaunch(url)){
                await launch(url,forceSafariVC: true);
              }else {
                throw 'Could not launch $url';
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(CupertinoIcons.search_circle),
                Text('Browse item'),
              ],
            )),
        TextButton(
            onPressed: () async{
              //Navigator.of(context).pop();
              print('tapped');
              try{
                if(await canLaunch('tel:${widget.wig_contact}')){
              await launch('tel:${widget.wig_contact}');
              }
              //await canLaunch('tel:0722494071');
              } catch(e){print(e);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.wig_contact),
                Icon(CupertinoIcons.phone),
              ],
            )
        ),
      ],
    );
  }
}
