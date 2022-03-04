import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jazia/custom_widgets/imagewidget.dart';
import 'package:jazia/trydart/uploadonly.dart';

import 'package:shared_preferences/shared_preferences.dart';

var date = ValueNotifier<DateTime>(DateTime.now());


class ProfileExisting extends StatefulWidget {
  const ProfileExisting({Key? key}) : super(key: key);

  @override
  _ProfileExistingState createState() => _ProfileExistingState();
}

class _ProfileExistingState extends State<ProfileExisting> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _inst;


  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;



  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('business')
      .doc('electronics')
      .collection('items')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: true,
           // backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: RichText(
                  text: TextSpan(
                      text: 'Jazia',
                      style: GoogleFonts.orbitron(
                        //textStyle:
                        //const TextStyle(color: Colors.blue, letterSpacing: .5),
                        fontSize: 21,
                        fontWeight: FontWeight.w200,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' advertise',
                            style: GoogleFonts.lexendDeca(
                                textStyle: const TextStyle(
                                    color: Colors.blueAccent, fontSize: 14)))
                      ])),
              //title: Text('Eatz Manager'),
              /* background: Image.asset('assets/Donuts-PNG-File.png',
              fit: BoxFit.cover,
              ),*/
            ),
            actions: <Widget>[
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_outlined),
                    onPressed: () async {
                      //Navigator.pushNamed(context, '/seventh');
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const UploadDialogBox();
                          });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.table_chart),
                    onPressed: () async {
                      //Navigator.pushNamed(context, '/eighth');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.link_off),
                    onPressed: () async {
                     // _signOutDialog();
                    },
                  ),
                ],
              ),
            ],
          ),
          SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text('My Jazia ads'),
                        ),
                        const Divider(
                          height: 5,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: _usersStream,
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading");
                            }

                            return Column(
                              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                return BodyWidget(
                                  wig_des: data['description'],
                                  wig_name: data['name'],
                                  wig_price: data['price'],
                                  wig_url: data['url'],
                                );
                                /*ListTile(
                                  leading: CircleAvatar(
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl:data["url"],
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                            CircularProgressIndicator(
                                                value:
                                                downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    'Item: ' + data["name"],
                                    style: GoogleFonts.ruda(),
                                  ),
                                  subtitle: Text(
                                    'Cost: ' + data["price"].toString(),
                                    style: GoogleFonts.mitr(),
                                  ),
                                  trailing: Text(
                                    'Details: ' +
                                        data['description'].toString(),
                                    style: GoogleFonts.sawarabiMincho(
                                        textStyle: const TextStyle(
                                            color: Colors.redAccent)),
                                  ),
                                  dense: true,
                                  //selected: true,
                                );*/
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ]
              ))
        ],
      ),
    );
  }
}
