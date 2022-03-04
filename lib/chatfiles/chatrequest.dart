import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jazia/chatfiles/chatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatReq extends StatefulWidget {
  const ChatReq({Key? key}) : super(key: key);

  @override
  _ChatReqState createState() => _ChatReqState();
}

class _ChatReqState extends State<ChatReq> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    setMessage(data) {
      firestore
          .collection('userSell')
          .doc(_auth.currentUser!.uid)
          .collection('messages')
          .doc(data['user'])
          .set({
        'messages': FieldValue.arrayUnion([
          {
            'message': data['message'],
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
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('business')
                  .doc('electronics')
                  .collection('requests')
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
                      onTap: () async {
                        firestore
                            .collection('userSell')
                            .doc(_auth.currentUser!.uid)
                            .collection('messages')
                            .doc(data['user'])
                            .get()
                            .then((value) {
                          /*   value.data()==null?  :print(value.data());*/

                          try {
                            List messages = value['messages'];

                            bool exists = false;
                            for (var element in messages) {
                              if (element['message'] == data['message']) {
                                exists = true;
                              }
                            }

                            print(exists);
                            !exists
                                ? setMessage((data))
                                : Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        appbar_name: data['name'],
                                        uid: data['user'])));
                          } catch (e) {
                            setMessage(data);
                            print(e.toString());
                          }
                        });

                        /*await firestore
                            .collection('userSell')
                            .doc(_auth.currentUser!.uid)
                            .collection('messages')
                            .doc(data['User'])
                            .set({
                          'messages': FieldValue.arrayUnion([
                            {
                              'message':data['Message'],
                              'name':_auth.currentUser!.displayName,
                              'type':'m',
                              'time':DateTime.now(),
                              'image':['https://testme','https://testme1',]
                            },
                          ])
                        },SetOptions(merge: true))
                            .then((value) =>  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    appbar_name: data['Name'],
                                    uid: data['User']
                                ))));*/
                      },
                      child: ListTile(
                          leading: CircleAvatar(
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: data["userUrl"],
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
