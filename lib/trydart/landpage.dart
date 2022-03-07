import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jazia/chatfiles/chatresponse.dart';
import 'package:jazia/custom_widgets/imagewidget.dart';
import 'package:jazia/trydart/gridcategory.dart';
import 'package:jazia/trydart/landorder.dart';
import 'package:jazia/trydart/test_api.dart';
import 'package:jazia/trydart/uploadonly.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../custom_widgets/items.dart';
import '../custom_widgets/tilesdata.dart';


String? landstream = 'items';

var date = ValueNotifier<DateTime>(DateTime.now());

class LandExisting extends StatefulWidget {
  const LandExisting({Key? key}) : super(key: key);

  @override
  _LandExistingState createState() => _LandExistingState();
}

class _LandExistingState extends State<LandExisting>
    with SingleTickerProviderStateMixin {

  int index = 0;
  bool _show = false;

  final PageController _pageController = PageController();
  late AnimationController _animationController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;



  // final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
  //     .collection('business')
  //     .doc(name)
  //     .collection('items')
  //     .snapshots();

  ///BOTTOM SHEET WIDGET
  ///
  ///

  Widget? _showBottomSheet() {
    if (_show) {
      return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6,
        /*child: BottomSheet(
          onClosing: () {

          },
          enableDrag: true,
          builder: (context) {
            return Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: ElevatedButton(
                child: Text("Close Bottom Sheet"),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.green,

                ),
                onPressed: () {
                  _show = false;
                  setState(() {

                  });
                },
              ),
            );
          },
        ),*/
        child: SolidBottomSheet(
          smoothness: Smoothness.high,
          draggableBody: true,
          headerBar: Container(
              color: Colors.transparent, height: 58, child: bottomBarRow()),
          body: Material(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    var data =
                    BottomSheetData().bottomSheetTiles[index];
                    return BottomBarTiles(
                      color: data['color'],
                      title: data['title'],
                      index: index,
                      image: data['image'],
                      subtitle: data['sub'],
                      hasSubtitle: data['hasSub'],
                      page: data['page'],
                    );
                  },
                  itemCount: BottomSheetData().bottomSheetTiles.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
              )),
        ),
      );
    } else {
      return null;
    }
  }

  ///WIDGET BOTTOMBAR
  ///

  Widget bottomBarRow() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Items(
              size: size,
              icon: Icons.home,
              onTap: () {
                _animationController.reset();
                _pageController.animateToPage(0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInCubic);
              },
              label: 'Home',
              color: index == 0
                  ? Theme.of(context).brightness == Brightness.light
                      ? Colors.teal
                      : Colors.red
                  : Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
          Items(
              size: size,
              icon: Icons.add_shopping_cart,
              onTap: () {
                _pageController.animateToPage(1,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInCubic);
              },
              label: 'Order',
              color: index == 1
                  ? Theme.of(context).brightness == Brightness.light
                      ? Colors.teal
                      : Colors.red
                  : Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
          Items(
              size: size,
              icon: Icons.home,
              onTap: () {
                _animationController.reset();
                _pageController.animateToPage(2,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInCubic);
              },
              label: 'Chat',
              color: index == 2
                  ? Theme.of(context).brightness == Brightness.light
                  ? Colors.teal
                  : Colors.red
                  : Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    if (mounted) {
      _animationController = AnimationController(
          duration: const Duration(seconds: 1), vsync: this);
    }
    super.initState();
  }
  var name ='electronics';
  void tap (nm){
    setState(() {
name=nm;
    });
    print(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int i) {
          setState(() {
            index = i;
          });
          print(index);
        },
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                pinned: true,
                snap: false,
                centerTitle: false,
                // backgroundColor: Colors.black,
                //title: Text('appBar', style:TextStyle(color: Colors.green),),
                //flexibleSpace: FlexibleSpaceBar(
                title: RichText(
                    text: TextSpan(
                        text: 'Jazia',
                        style: GoogleFonts.orbitron(
                          textStyle: const TextStyle(
                             // color: Colors.red,
                              letterSpacing: .5),
                          fontSize: 23,
                          fontWeight: FontWeight.w200,
                        ),
                        children: <TextSpan>[
                      TextSpan(
                          text: ' Window Mode',
                          style: GoogleFonts.lexendDeca(
                              textStyle: const TextStyle(
                                  color: Colors.blueAccent, fontSize: 14)))
                    ])),
                //),
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
                          Navigator.pushNamed(context, '/landorder');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.link_off),
                        onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TestLoan()));

                        },
                      ),
                    ],
                  ),
                ],
                bottom: AppBar(
                  title: Row(
                    children: [
                      Container(
                        //width: double.infinity,
                        width: MediaQuery.of(context).size.width / 1.4,
                        height: 40,
                        //color: Colors.white,
                        child: const Center(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search for something',
                              prefixIcon: Icon(Icons.search),
                              // suffixIcon: Icon(Icons.camera_alt)
                            ),
                          ),
                        ),
                      ),
                      /* Padding(
                padding: EdgeInsets.only(left: 10.0),
                child:  CupertinoSwitch(
                  value: _lights,
                  onChanged: (bool value) {
                    setState(() {
                      _lights = value;
                    });
                  },
                ),
                */ /*child: ToggleSwitch(
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
                ),*/ /*
              ),*/
                    ],
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('Swipe to make a specific order to all sellers >>'),
                    ),
                    const Divider(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                        ),
                        height: MediaQuery.of(context).size.height / 3,
                        width: double.infinity,
                        //color: Colors.greenAccent,
                        child: GridWidget(tap: tap,),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection('business')
                          .doc(name)
                          .collection('items')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('Sorry, Check your connection!'),);
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        return Column(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
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
              ]))
            ],
          ),
          LandOrder(),
          ChatResponse(),
        ],
      ),
      bottomSheet: _showBottomSheet(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
        if(_show){
          setState(() {
            _show = false;
          });
        } else{
          setState(() {
            _show = true;
          });
        }
      },
      child: _show?Icon(Icons.arrow_downward):Icon(Icons.arrow_upward),),
    );
  }
}

