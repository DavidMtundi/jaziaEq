import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:jazia/chatfiles/chatpage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetName extends StatefulWidget {
  String wig_name, wig_contact;
  GetName({Key? key, required this.wig_name, required this.wig_contact}) : super(key: key);

  @override
  _GetNameState createState() => _GetNameState();
}

class _GetNameState extends State<GetName> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///UPLOAD THE ITEM TO DB
  ///

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CupertinoAlertDialog(
      title: Text(widget.wig_name.toString()),
      content: Text('Condition: Brandnew'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
             /* setMessage(data) {
                firestore
                    .collection('userSell')
                    .doc(_auth.currentUser!.uid)
                    .collection('messages')
                    .doc(data['user'])
                    .set({
                  'messages': FieldValue.arrayUnion([
                    {
                      'message': data['message'],
                      'name': _auth.currentUser!.displayName,
                      'type': 'm',
                      'time': DateTime.now(),
                      'image': [
                        'https://testme',
                        'https://testme1',
                      ]
                    },
                  ])
                }, SetOptions(merge: true)).then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatPage(appbar_name: data['name'], uid: data['user']))));
              }*/
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(CupertinoIcons.chat_bubble_text),
                Text('Lets Chat'),
              ],
            )),
        TextButton(
            onPressed: () async{
             Navigator.of(context).pop();
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
