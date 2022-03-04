import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jazia/chatfiles/chatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jazia/chatfiles/chatpageuser.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatResponse extends StatefulWidget {
  const ChatResponse({Key? key}) : super(key: key);

  @override
  _ChatResponseState createState() => _ChatResponseState();
}

class _ChatResponseState extends State<ChatResponse> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
   /* setMessage(data) {
      firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .collection('messages')
          .doc(data['user'])
          .set({
        'messages': FieldValue.arrayUnion([
          {
            'message': data['Message'],
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Responses for ${_auth.currentUser!.displayName}'),
      ),
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .collection('responses')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Sorry, Check your connection!'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return Column(
                  children:
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    return InkWell(
                      onTap: ()  {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPageUser(
                                appbar_name: data['name'],
                                uid: data['resUid'])));
                      },
                      child: ListTile(
                          leading: CircleAvatar(
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: data["resUrl"],
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
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                          ),
                          title: Text(
                            data["name"],
                            style: GoogleFonts.ruda(),
                          ),
                          subtitle: Text(
                            data["message"].toString(),
                            style: GoogleFonts.mitr(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            timeago.format(data['time'].toDate()),
                            style: GoogleFonts.sawarabiMincho(
                                textStyle:
                                const TextStyle(color: Colors.greenAccent)),
                          ) //selected: true,
                      ),
                    );
                  }).toList(),
                );
              })),
    );
  }
}
