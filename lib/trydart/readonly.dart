import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jazia/custom_widgets/imagewidget.dart';
import 'package:jazia/main.dart';
import 'package:jazia/screens/categoryseller.dart';
import 'package:jazia/trydart/uploadonly.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'expandable_floating_button.dart';

var date = ValueNotifier<DateTime>(DateTime.now());

@immutable
class ProfileExisting extends StatefulWidget {
  String? categoryVal;
   ProfileExisting({Key? key, this.categoryVal}) : super(key: key);

  @override
  _ProfileExistingState createState() => _ProfileExistingState();
}

class _ProfileExistingState extends State<ProfileExisting> {


  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? category;

  Future<void> getCategory() async {
    firestore.collection('userSell').doc(_auth.currentUser!.uid).get().then((value) {
      var getcategory = value['category'];
      setState(() {
        category = getcategory;
      });
      print(category);
    });
  }


  String cat='electronics';
  SharedPreferences? pref;
  getDetails()async{
    pref = await SharedPreferences.getInstance();
    setState(() {
      cat = pref!.getString('category')!;
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    getDetails();
    getCategory();

    super.initState();
  }



/*  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('business')
      .doc(widget.categoryVal)
      .collection('items')
      .snapshots();*/
  @override
  Widget build(BuildContext context) {

    String? dropdownvalue = category;
    var items = [
      'electronics',
      'art',
      'clothing',
      'phones',
      'property',
      'construction equipment',
      'toys',
      'vehicles',
    ];

    if(cat.isEmpty){
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
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
                        DropdownButton(
                          value: dropdownvalue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged:  (String? newValue) async {

                                dropdownvalue = newValue!;
                                category = newValue;
                              setState(() { });
                            },
                        ),
                        const Divider(
                          height: 5,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: firestore.collection('business')
                              .doc(category)
                              .collection('items')
                              .where('uid', isEqualTo: _auth.currentUser!.uid)
                              .snapshots(),
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
                                  wig_contact: data['phone'],
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
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () async {
              print('GHI');
              getCategory();
            },
            icon: const Icon(Icons.help_outline),
          ),
          ActionButton(
            onPressed: () => getTheme(),
            icon: const Icon(Icons.settings_outlined),
          ),
          ActionButton(
            onPressed: () async{
              print('DEF');
              //showDialog(context: context, builder: (context){
                //return CategorySeller(wig_category: category,);
              //});
            },
            icon: const Icon(Icons.list),
          ),
          ActionButton(
            onPressed: () async{
              Navigator.pushNamed(context, '/chatrequests');

            },
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),
          ActionButton(
            onPressed: () async{
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const UploadDialogBox();
                  });
            },
            icon: const Icon(Icons.add_circle_outline_outlined),
          ),
        ],
      ),
    );
  }
}
