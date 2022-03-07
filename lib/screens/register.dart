// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

TextStyle _style = GoogleFonts.varelaRound();
var accountNumber = ValueNotifier<String>('');


class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController idnumber = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  String gender = '';
  String dropDownValue = 'equity';
  String documentName = '';
  DateTime dateTime = DateTime.now();
  bool validated = false;
  bool processing = false;
  String firstName = '';
  String lastName = '';
  String id = '';
  String bankName = '';

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Widget courses() {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('banks').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select your Bank',
                        style: _style,
                      ),
                      DropdownButton<dynamic>(
                        value: dropDownValue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: snapshot.data!.docs.map((element) {
                          return DropdownMenuItem(
                              value: element.id,
                              child: Text(element['name'],
                                  style: GoogleFonts.varela(fontSize: 11)));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            dropDownValue = newValue.toString();
                            accountNumber.value = '';
                          });

                          // splitDocName(newValue);
                          dropDownValue == 'equity'
                              ? showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeptDialog(
                                        document: dropDownValue,
                                        id: idnumber.text,
                                        firstName: firstname.text,
                                        lastName: lastname.text);
                                  })
                              : Fluttertoast.showToast(
                                  msg:
                                      'this bank is not currently supported for jazia services',
                                  toastLength: Toast.LENGTH_LONG);
                        },
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.blue
            : Colors.red,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                        onTap: () => getTheme(), child: Icon(iconData))),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Let\'s finish setting you up...',
                        style: _style.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Card(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.blue
                            : Colors.red,
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45)),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const SizedBox(
                              height: 90,
                              width: 90,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              child: SizedBox(
                                height: 80,
                                width: 80,
                                child: Center(
                                  child: Text(
                                    user!.email
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: GoogleFonts.modak(fontSize: 60),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(user!.email.toString(),
                          style: _style.copyWith(
                              fontSize: 11,
                              fontFamily: GoogleFonts.monda().fontFamily,
                              letterSpacing: 2)),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        //color: Colors.blueGrey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  child: TextFormField(
                                    controller: firstname,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'first name is required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      fillColor: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.blue.withOpacity(.1)
                                          : Colors.red.withOpacity(.1),
                                      filled: true,
                                      labelText: 'first name',
                                      labelStyle: _style.copyWith(fontSize: 12),

                                      // border: OutlineInputBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(10))
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  child: TextFormField(
                                    controller: lastname,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'last name is required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      fillColor: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.blue.withOpacity(.1)
                                          : Colors.red.withOpacity(.1),
                                      filled: true,
                                      labelText: 'last name',
                                      labelStyle: _style.copyWith(fontSize: 12),
                                      // border: OutlineInputBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(10))
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: idnumber,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'please enter your identification number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.blue.withOpacity(.1)
                                    : Colors.red.withOpacity(.1),
                                filled: true,
                                labelText: 'identification number',
                                labelStyle: _style.copyWith(fontSize: 12),
                                // border: OutlineInputBorder(
                                //     borderRadius:
                                //         BorderRadius.circular(10))
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: idnumber,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'please enter your Phone number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).brightness ==
                                    Brightness.light
                                    ? Colors.blue.withOpacity(.1)
                                    : Colors.red.withOpacity(.1),
                                filled: true,
                                labelText: 'Phone number',
                                labelStyle: _style.copyWith(fontSize: 12),
                                // border: OutlineInputBorder(
                                //     borderRadius:
                                //         BorderRadius.circular(10))
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Divider(
                              indent: 30,
                              endIndent: 30,
                              thickness: .5,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                            courses(),
                            ValueListenableBuilder(
                              builder: (context, value, widget) {
                                return accountNumber.value.isEmpty
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return DeptDialog(
                                                      document: documentName,
                                                      id: idnumber.text,
                                                      firstName: firstname.text,
                                                      lastName: lastname.text);
                                                });
                                          },
                                          child: Text(
                                            'account number: ${accountNumber.value}',
                                            style: _style.copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      );
                              },
                              valueListenable: accountNumber,
                            ),
                            // ValueListenableBuilder(
                            //   builder: (context, value, widget) {
                            //     return course.value.isEmpty
                            //         ? const SizedBox()
                            //         : Padding(
                            //             padding: const EdgeInsets.only(
                            //                 top: 12.0, bottom: 8.0),
                            //             child: InkWell(
                            //               onTap: () {},
                            //               child: Text(
                            //                 'Course: ${course.value}',
                            //                 style: _style.copyWith(
                            //                   decoration:
                            //                       TextDecoration.underline,
                            //                 ),
                            //               ),
                            //             ),
                            //           );
                            //   },
                            //   valueListenable: course,
                            // ),
                            // Divider(
                            //   indent: 30,
                            //   endIndent: 30,
                            //   thickness: .5,
                            //   color: Theme.of(context).brightness ==
                            //           Brightness.dark
                            //       ? Colors.red
                            //       : Colors.blue,
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                                bottom: 5,
                              ),
                              child: Text(
                                'Gender',
                                style: _style,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    value: 'male',
                                    groupValue: gender,
                                    onChanged: (val) {
                                      setState(() {
                                        gender = val.toString();
                                      });
                                      print(gender);
                                    }),
                                Text(
                                  'male',
                                  style: _style.copyWith(fontSize: 12),
                                ),
                                Radio(
                                    value: 'female',
                                    groupValue: gender,
                                    onChanged: (val) {
                                      setState(() {
                                        gender = val.toString();
                                      });
                                      print(gender);
                                    }),
                                Text(
                                  'female',
                                  style: _style.copyWith(fontSize: 12),
                                ),
                                Radio(
                                    value: 'other',
                                    groupValue: gender,
                                    onChanged: (val) {
                                      setState(() {
                                        gender = val.toString();
                                      });
                                      if (kDebugMode) {
                                        print(gender);
                                      }
                                    }),
                                Text(
                                  'other',
                                  style: _style.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                            Divider(
                              indent: 30,
                              endIndent: 30,
                              thickness: .5,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text('Select Date of Birth', style: _style),
                                const SizedBox(
                                  width: 30,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      setState(() {});
                                      var newDate = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1990),
                                          initialDate: DateTime.now(),
                                          lastDate: DateTime.now(),
                                          currentDate: DateTime.now(),
                                          useRootNavigator: false);
                                      print(newDate);
                                      if (newDate != null) {
                                        setState(() {
                                          dateTime = newDate;
                                        });
                                        print(dateTime);
                                      }
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.calendar,
                                      size: 35,
                                    )),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  '${dateTime.year.toString()}/${dateTime.month.toString()}/${dateTime.day.toString()}',
                                  style: _style,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              indent: 30,
                              endIndent: 30,
                              thickness: .5,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: !processing
                                      ? () {
                                          if (!_formKey.currentState!
                                              .validate()) {
                                          } else if (gender.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please select your gender',
                                                // textColor: Colors.red,
                                                toastLength: Toast.LENGTH_LONG);
                                          }else if ((DateTime.now().year -
                                                  dateTime.year) <
                                              18) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'provide a valid date of birth',
                                                //textColor: Colors.red,
                                                toastLength: Toast.LENGTH_LONG);
                                          } else {
                                            setState(() {
                                              validated = true;
                                              processing = true;
                                              firstName = firstname.text;
                                              lastName = lastname.text;
                                              id = idnumber.text;
                                            });
                                            firestore.collection('users').doc(user!.uid).set({
                                              'accountnumber':accountNumber.value,
                                              'idnumber':idnumber.text,
                                              'first_name':firstname.text,
                                              'last_name':lastname.text,
                                              'uid':user!.uid,
                                              'gender':gender,
                                              'DOB':dateTime,
                                              'linked':true,

                                            }).then((value){
                                              Navigator.of(context).pop();
                                              setState(() {
                                                processing = false;
                                              });
                                            });
                                          }
                                        }
                                      : () {
                                          Fluttertoast.showToast(
                                              msg: 'please wait...');
                                        },
                                  child: !processing
                                      ? Container(
                                          height: 50,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.red
                                                    : Colors.blue,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Continue',
                                                style: _style.copyWith(
                                                    color: Colors.white),
                                              ),
                                              const Icon(
                                                CupertinoIcons.forward,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class DeptDialog extends StatefulWidget {
  const DeptDialog(
      {Key? key,
      required this.document,
      required this.id,
      required this.firstName,
      required this.lastName})
      : super(key: key);
  final String document;
  final String id;
  final String firstName;
  final String lastName;
  @override
  _DeptDialogState createState() => _DeptDialogState();
}

class _DeptDialogState extends State<DeptDialog> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController accNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CupertinoAlertDialog(
        title: Text(widget.document == 'equity' ? 'Equity Bank' : ''),
        content: StreamBuilder<DocumentSnapshot>(
            stream:
                firestore.collection('banks').doc(widget.document).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              return snapshot.hasData
                  ? Material(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'please provide your account number below for authorization'),
                              Divider(),
                              Text('first name: ${widget.firstName.isEmpty?'not provided':widget.firstName }'),
                              Divider(),
                              Text('last name: ${widget.lastName.isEmpty?'not provided':widget.lastName }'),
                              Divider(),
                              Text('identification number: ${widget.id.isEmpty?'not provided':widget.id }'),
                              Divider(),

                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: accNoController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'account number is required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.blue.withOpacity(.1)
                                    : Colors.red.withOpacity(.1),
                                filled: true,
                                labelText: 'account number',
                                labelStyle: _style.copyWith(fontSize: 12),

                                // border: OutlineInputBorder(
                                //     borderRadius:
                                //         BorderRadius.circular(10))
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container();
            }),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: Text('cancel')),
          TextButton(onPressed: () {
            accountNumber = ValueNotifier(accNoController.text);
             Navigator.of(context).pop();
          }, child: Text('OK'))
        ],
      ),
    );
  }
}
