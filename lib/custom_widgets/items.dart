// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Items extends StatelessWidget {
  const Items({
    Key? key,
    required this.size,
    required this.icon,
    required this.onTap,
    required this.label,
    required this.color,
  }) : super(key: key);

  final size;
  final IconData icon;
  final Function() onTap;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadiusDirectional.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            width: size.width / 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: color,
                ),
                Text(
                  label,
                  style: GoogleFonts.varela(
                      fontSize: 12, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomBarTiles extends StatefulWidget {
  const BottomBarTiles(
      {Key? key,
        this.image,
        this.title,
        this.hasSubtitle,
        this.subtitle,
        this.index,
        this.color,
      this.page})
      : super(key: key);
  final image;
  final title;
  final hasSubtitle;
  final subtitle;
  final index;
  final color;
  final page;
  @override
  _BottomBarTilesState createState() => _BottomBarTilesState();
}

class _BottomBarTilesState extends State<BottomBarTiles> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkSell () async {

        var checkUserSeller = firestore.collection('userSell').where('uid', isEqualTo: _auth.currentUser!.uid).get();
        checkUserSeller.then((value) {
          try{
            Navigator.pushNamed(context, '/myitems');
            print(value.docs.first.id);
        } catch(e){
            print(e);
            Navigator.pushNamed(context, '/verifyseller');
          }
      });

  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      onTap: () {
        if (kDebugMode) {
          print(widget.title);
          print(widget.page);
        }
        if(widget.title == 'Sell an item'){
          if (kDebugMode) {
            print('Sell an item confirmed');
          }
          checkSell();
        } else {
          Navigator.pushNamed(context, widget.page);
        }
      },
      leading: Card(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                color: widget.color, borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Image.asset(
                widget.image,
                height: 25,
                width: 25,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        widget.title,
        style: GoogleFonts.varela(),
      ),
      subtitle: widget.hasSubtitle ? Text(widget.subtitle) : SizedBox(),
    );
  }
}