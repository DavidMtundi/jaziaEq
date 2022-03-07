import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jazia/chatfiles/chatpage.dart';
import 'package:jazia/screens/mySaving.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

TextStyle _style = GoogleFonts.varelaRound();

class JaziaQuerySave extends StatefulWidget {
  String wig_name, wig_url, wig_contact, wig_des;
  int wig_price;

  JaziaQuerySave({Key? key, required this.wig_name, required this.wig_price, required this.wig_url, required this.wig_des, required this.wig_contact}) : super(key: key);

  @override
  _JaziaQuerySaveState createState() => _JaziaQuerySaveState();
}

class _JaziaQuerySaveState extends State<JaziaQuerySave> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController amountController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///UPLOAD THE ITEM TO DB
  ///

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CupertinoAlertDialog(
      title: Text('Creating a savings account'),
      content: Column(
        children: [
          Text(
              'You are about to create a savings account called:'
          ),
          Text(widget.wig_name, style: GoogleFonts.oswald(fontWeight: FontWeight.bold,fontSize: 23),)
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              firestore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .collection('savings')
                  .doc(widget.wig_name)
                  .set({
                'item':widget.wig_name,
                'name':_auth.currentUser!.uid,
                'amountSaved':'0.00',
                'amountPending':widget.wig_price,
                'url':widget.wig_url,
                'contact':widget.wig_contact,
                'description':widget.wig_des,
                'price':widget.wig_price
              });

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MySaving()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Proceed'),
                Icon(CupertinoIcons.arrow_right),
              ],
            )),
      ],
    );
  }
}
