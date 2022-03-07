import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jazia/custom_widgets/imagewidget.dart';

class MySaving extends StatefulWidget {
  const MySaving({Key? key}) : super(key: key);

  @override
  _MySavingState createState() => _MySavingState();
}

class _MySavingState extends State<MySaving> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items saving for'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('savings')
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
             // try{
                return Card(
                  elevation: 8,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                const Text('Name: '),

                                Text(data['item']),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                const Text('Saved Amount: '),

                                Text(data['amountSaved'].toString()),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Text('Pending Amount:  '),

                                Text(data['amountPending'].toString()),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Text('Seller Contact: '),

                                Text(data['contact']),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Text('Description:  '),

                                Flexible(child: Text(data['description'].toString(),overflow: TextOverflow.fade,)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              /*}catch(e){
                return Container();
              }*/

            }).toList(),
          );
        },
      ),
    );
  }
}
