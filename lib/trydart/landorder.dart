import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jazia/custom_widgets/imagewidget.dart';
import 'package:jazia/trydart/gridcategory.dart';
import 'package:jazia/trydart/uploadonly.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:shared_preferences/shared_preferences.dart';

var date = ValueNotifier<DateTime>(DateTime.now());


class LandOrder extends StatefulWidget {
  const LandOrder({Key? key}) : super(key: key);

  @override
  _LandOrderState createState() => _LandOrderState();
}

class _LandOrderState extends State<LandOrder> {
  late List<String> instructions;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _inst;

  TextEditingController? _controller;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;



  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('business')
      .doc('electronics')
      .collection('items')
      .snapshots();

  var _lights = true;

  @override
  void initState() {
    // TODO: implement initState
    instructions = [
      'Are you looking for a product with very specific specs?',
      'E.g specific laptop specs (Laptop, 24gb ram, 1tb ssd, pink color, 2.5ghz)',
      'Jazia Order Mode has got you covered. ',
      '[Optional] Attach a file indicating detailed specs or an image showing product required',
      'Kindly provide more information about your request in the text area'
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            // backgroundColor: Colors.black,
            //title: Text('appBar', style:TextStyle(color: Colors.green),),
            flexibleSpace: FlexibleSpaceBar(
            title: RichText(
                text: TextSpan(
                    text: 'Jazia',
                    style: GoogleFonts.orbitron(
                      textStyle:
                      const TextStyle(color: Colors.red, letterSpacing: .5),
                      fontSize: 23,
                      fontWeight: FontWeight.w200,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Order Mode',
                          style: GoogleFonts.lexendDeca(
                              textStyle: const TextStyle(
                                  color: Colors.blueAccent, fontSize: 14)))
                    ])),
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
          /*  bottom: AppBar(
              title: Row(
                children: [
                 *//* Container(
                    //width: double.infinity,
                    width: MediaQuery.of(context).size.width/1.4,
                    height: 40,
                    color: Colors.white,
                    child: const Center(
                      child:
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for something',
                          prefixIcon: Icon(Icons.search),
                          // suffixIcon: Icon(Icons.camera_alt)
                        ),
                      ),
                    ),
                  ),*//*
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child:  CupertinoSwitch(
                      value: _lights,
                      onChanged: (bool value) {
                        setState(() {
                          _lights = value;
                        });
                      },
                    ),
                    *//*child: ToggleSwitch(
              minWidth: 35.0,
              minHeight: 20.0,
              cornerRadius: 20.0,
              activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              initialLabelIndex: 1,
              totalSwitches: 2,
              labels: ['', ''],
              radiusStyle: true,
              onToggle: (index) {
                print('switched to: $index');
              },
            ),*//*
                  ),
                ],
              ),
            ),*/
          ),
          SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: [
                        const Divider(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('instructions: '),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 160,
                            width: size.width,
                            child: ListView.separated(
                              itemCount: instructions.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(
                                  '${(index + 1).toString()}. ${instructions[index]}',
                                  style: GoogleFonts.montserratAlternates(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 10,
                                );
                              },
                            ),
                          ),
                        ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Enter your request below; Jazia will find the product for you 👍',
                style: GoogleFonts.varela(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLength: 500,
                controller: _controller,
                maxLines: 8,
                decoration: InputDecoration.collapsed(
                    fillColor: Colors.teal.withOpacity(.1),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Enter your text here"),
              ),
            ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: (){}, child: Text('Submit')
                            ),
                          ),
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
