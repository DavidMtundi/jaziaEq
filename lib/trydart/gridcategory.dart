import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jazia/trydart/landpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


class GridWidget extends StatefulWidget {
  const GridWidget({Key? key, required this.tap}) : super(key: key);

final Function tap;
  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  SharedPreferences? pref;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('business').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) => snapshot.hasData?GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 8.0,
                          children: snapshot.data!.docs.map((doc)=>
                              InkWell(
                                hoverColor: Colors.red,
                                onTap: ()async{
                                  pref = await SharedPreferences.getInstance();
                                   pref!.setString('landStream', doc.id);
                                  landstream = pref!.getString('landStream');
                                   widget.tap(landstream);
                                  // print(landstream);

                                },
                                child: Card(
                                  elevation: 11,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ///TODO: HAPA NITAFIKIRIA KESHO
                                      Expanded(
                                         // child: Image.network(doc['iconurl']),
                                        child: CachedNetworkImage(
                                          imageUrl: doc['iconurl'],
                                          imageBuilder: (context, imageProvider) =>
                                              Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
//                                                colorFilter:
//                                                ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                                  ),
                                                ),
                                              ),
                                          //placeholder: (context, url) => CircularProgressIndicator(),
                                          progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                             const Center(
                                                child: CupertinoActivityIndicator(
                                                    //value: downloadProgress.progress
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                        ),
                                      ),
                                Text(doc.id),
                                    ],
                                  ),
                                ),
                              ),

                          ).toList()

                      ):CupertinoActivityIndicator()
    );

  }
}
