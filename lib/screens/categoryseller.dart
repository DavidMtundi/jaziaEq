// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:jazia/chatfiles/chatpage.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// TextStyle _style = GoogleFonts.varelaRound();
//
// class CategorySeller extends StatefulWidget {
// String? wig_category;
//   CategorySeller({Key? key, required this.wig_category}) : super(key: key);
//
//
//   @override
//   _CategorySellerState createState() => _CategorySellerState();
// }
//
// class _CategorySellerState extends State<CategorySeller> {
//   FirebaseStorage storage = FirebaseStorage.instance;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   TextEditingController amountController = TextEditingController();
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//
//   ///UPLOAD THE ITEM TO DB
//   ///
//
//   @override
//   Widget build(BuildContext context) {
//
//     String? dropdownvalue = widget.wig_category;
//     var items = [
//       'electronics',
//       'art',
//       'clothing',
//       'phones',
//       'property',
//       'construction equipment',
//       'toys',
//       'vehicles',
//     ];
//
//     Size size = MediaQuery.of(context).size;
//     return CupertinoAlertDialog(
//       title: Text('My Uploads'),
//       content: Material(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text('Select Category to view'),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: DropdownButton(
//                   value: dropdownvalue,
//                   icon: const Icon(Icons.keyboard_arrow_down),
//                   items: items.map((String items) {
//                     return DropdownMenuItem(
//                       value: items,
//                       child: Text(items),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) async {
//                     setState(() {
//                       dropdownvalue = newValue!;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//             onPressed: () async{
//
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children:  [
//                 Text('Proceed'),
//                 Icon(CupertinoIcons.arrow_right),
//               ],
//             )
//         ),
//       ],
//     );
//   }
// }
