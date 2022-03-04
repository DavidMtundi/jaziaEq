import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart';

class ChatPageUser extends StatefulWidget {
  final String appbar_name, uid;
  ChatPageUser({Key? key, required this.appbar_name, required this.uid}) : super(key: key);

  @override
  _ChatPageUserState createState() => _ChatPageUserState();
}

class _ChatPageUserState extends State<ChatPageUser> {

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final double _inputHeight = 50;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appbar_name+"'s Response"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<DocumentSnapshot>(
              stream: firestore.collection('userSell').doc(widget.uid).collection('messages').doc(widget.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

                if(snapshot.hasError){
                  return const Center(
                    child: Text('Sorry, Check your connection!'),
                  );
                }

                if(snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }
                List messages = snapshot.data!['messages'];
                return SingleChildScrollView(
                  child: Column(
                    children:
                    messages.map((message) {
                      return Container(
                        child: message['type'] == 'r'
                            ?
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20)),
                              width: MediaQuery.of(context).size.width * .7,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Text(
                                    message['message'],
                                    style: GoogleFonts.heebo(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                            :
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red[800],
                                  borderRadius: BorderRadius.circular(20)),
                              width: MediaQuery.of(context).size.width * .7,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Text(
                                    message['message'],
                                    style: GoogleFonts.heebo(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Scrollbar(
                        controller: _scrollController,
                        isAlwaysShown: true,
                        child: Container(
                          height: _inputHeight,
                          child: TextField(
                            scrollController: _scrollController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: _controller,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: Icon(
                                Icons.message,
                                size: 15,
                              ),
                              labelText: 'type here',
                              labelStyle: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        splashRadius: 24,
                        onPressed: () async{
                          _controller.text.isEmpty
                              ?
                          print('empty')
                              :
                          await firestore
                              .collection('userSell')
                              .doc(_auth.currentUser!.uid)
                              .collection('messages')
                              .doc(widget.uid)
                              .set({
                            'messages':FieldValue.arrayUnion([
                              {
                                'message':_controller.text,
                                'name':_auth.currentUser!.displayName,
                                'type':'r',
                                'time':DateTime.now(),
                                'image':['https://testme','https://testme1',]
                              },
                            ])
                          },SetOptions(merge: true)).then((value) {
                            setState(() {
                              _controller.clear();
                            });
                          });
                        },
                        icon: Icon(Icons.send))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                const Text(
                  'Response goes here 👆',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
