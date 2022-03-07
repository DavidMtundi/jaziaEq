import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBorrow extends StatefulWidget {
  const MyBorrow({Key? key}) : super(key: key);

  @override
  _MyBorrowState createState() => _MyBorrowState();
}

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class _MyBorrowState extends State<MyBorrow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowed for Jazia'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot? doc = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height/3,
                width: MediaQuery.of(context).size.width,
                child: Card(
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

                                  Text(doc!['name']),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  const Text('Linked: '),

                                  Text(doc['linked'].toString()),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Text('FullyPaid:  '),

                                  Text(doc['fullyPaid'].toString()),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Text('InterestRate:  '),

                                  Text(doc['interestRate'].toString()+'%'.toString()),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Text('AmountPayable:  '),

                                  Text(doc['amountpayable'].toString()),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Text('OutstandingLoan:  '),

                                  Text(doc['outstandingLoan'].toString()),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Text('Date Due: '),

                                  Text(doc['dateDue']),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Text('DateIssued:  '),

                                  Flexible(child: Text(doc['dateIssued'].toString(),overflow: TextOverflow.fade,)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                ),
              ),
            );
          } else {
            return Text('none');
          }
        },
      ),
    );
  }
}
