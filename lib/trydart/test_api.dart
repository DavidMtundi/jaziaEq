// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

ValueNotifier<Map<String, dynamic>> data = ValueNotifier({});

class TestLoan extends StatefulWidget {
  const TestLoan({Key? key}) : super(key: key);

  @override
  State<TestLoan> createState() => _TestLoanState();
}

class _TestLoanState extends State<TestLoan> {
  Uri url = Uri(
      scheme: 'http',
      host: '9b08-41-89-229-17.ngrok.io',
      path: '/simulateloan',
      queryParameters: {
        'id': "GmYuZn2uZn3edmZydm",
        'key': "9xke8x>luw6}Y<-M2-EZefp}7W,sj2P,8]A4U7Lu",
        'amount': "1000",
        'period': "6"
      });

  getData() async {
    try {
      var res = await http.get(
        url,
      );
      if (res.statusCode == 200) {
        setState(() {});
        data = ValueNotifier(jsonDecode(res.body.trim()));
        print(jsonDecode(res.body.trim()));
        isLoading = false;
      } else {
        setState(() {});
        isLoading = false;
        data = ValueNotifier(jsonDecode(res.body.trim()));
        print(jsonDecode(res.body.trim()));
      }
    } catch (e) {
      print(e);
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: data,
        builder: (context, value, child) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  data.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            (data.value['accepted']
                                ? data.value['loanMessage'].toString()
                                : data.value['info'].toString() +
                                    '\n' +
                                    'date due: ' +
                                    data.value['dateDue'].toString() +
                                    '\n' +
                                    'interest rate: ' +
                                    data.value['interestRate'].toString() +'%' +
                                    '\n' +
                                    'amount payable ' +
                                    data.value['amountPayable'].toString()),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.aBeeZee(fontSize: 18),
                          ),
                        )
                      : !isLoading
                          ? SizedBox()
                          : CupertinoActivityIndicator(),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        getData();
                      },
                      child: Text('check loan limit'))
                ],
              ),
            ),
          );
        });
  }
}
