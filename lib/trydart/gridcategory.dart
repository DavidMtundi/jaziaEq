import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class GridWidget extends StatefulWidget {
  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('business').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) => snapshot.hasData?GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 8.0,
                          children: snapshot.data!.docs.map((doc)=>Card(child: Text(doc.id),),).toList()
                          // List.generate(choices.length, (index) {
                          //   return Center(
                          //     child: SelectCard(choice: choices[index]),
                          //   );
                          // }
                          // )
                      ):CupertinoActivityIndicator()
    );
    // return GridView.count(
    //             crossAxisCount: 3,
    //             crossAxisSpacing: 4.0,
    //             mainAxisSpacing: 8.0,
    //             children: List.generate(choices.length, (index) {
    //               return Center(
    //                 child: SelectCard(choice: choices[index]),
    //               );
    //             }
    //             )
    //         );
  }
}
//
// class Choice {
//    Choice({this.title, this.icon});
//   final String? title;
//   final IconData? icon;
// }
//
//  List<Choice> choices =  <Choice>[
//     Choice(title: 'Home', icon: Icons.home),
//    Choice(title: 'Contact', icon: Icons.contacts),
//    Choice(title: 'Map', icon: Icons.map),
//    Choice(title: 'Phone', icon: Icons.phone),
//    Choice(title: 'Camera', icon: Icons.camera_alt),
//    Choice(title: 'Setting', icon: Icons.settings),
//    Choice(title: 'Album', icon: Icons.photo_album),
//    Choice(title: 'WiFi', icon: Icons.wifi),
// ];
//
// class SelectCard extends StatelessWidget {
//    SelectCard({Key? key, this.choice}) : super(key: key);
//   final Choice? choice;
//
//   @override
//   Widget build(BuildContext context) {
//     final TextStyle? textStyle = Theme.of(context).textTheme.bodyText1;
//     return Card(
//       elevation: 11,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         //color: Colors.orange,
//         child: Center(child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Expanded(child: Icon(choice!.icon, size:50.0, color: textStyle!.color)),
//               Text(choice!.title!,
//                  style: textStyle
//               ),
//             ]
//         ),
//         )
//     );
//   }
// }