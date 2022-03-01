// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/auth.dart';
import '../services/bouncy.dart';
ValueNotifier<bool> isGoogleLoading=ValueNotifier(false);
ValueNotifier<bool> isFacebookLoading=ValueNotifier(false);
class SigninButtons extends StatefulWidget {
  const SigninButtons({Key? key}) : super(key: key);

  @override
  State<SigninButtons> createState() => _SigninButtonsState();
}

class _SigninButtonsState extends State<SigninButtons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    if (mounted) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 500,
        ),
        lowerBound: 0.0,
        upperBound: 0.1,
      )..addListener(() {
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: ValueListenableBuilder(
          valueListenable: isFacebookLoading,
          builder: (context,v,c) {
            return ValueListenableBuilder(
                valueListenable: isGoogleLoading,
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                            AuthService().signInWithGoogle();
                            },
                            onTapDown: _tapDown,
                            onTapUp: _tapUp,
                            child: AnimatedButton(
                              controller: _controller,
                              child: Card(
                                  elevation: 15,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: !isGoogleLoading.value
                                        ? Image.asset(
                                      'assets/google-logo.png',
                                      height: 40,
                                      width: 40,
                                      filterQuality: FilterQuality.high,
                                    )
                                        : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.transparent,
                                                color: Colors.red,
                                                strokeWidth: .9,
                                              )),
                                        )),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Google',
                                style: GoogleFonts.ubuntu(color: Colors.red)),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: VerticalDivider(),
                          ),
                          Center(
                            child: Container(
                              child: Center(
                                  child: Text(
                                    'or',
                                    style: GoogleFonts.ubuntu(color: Colors.white),
                                  )),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {

                            },
                            onTapDown: _tapDown,
                            onTapUp: _tapUp,
                            child: AnimatedButton(
                              controller: _controller,
                              child: Card(
                                  elevation: 15,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: !isFacebookLoading.value
                                        ? Image.asset(
                                      'assets/microsoft.png',
                                      height: 40,
                                      width: 40,
                                      filterQuality: FilterQuality.high,
                                    )
                                        : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.transparent,
                                                color: Colors.red,
                                                strokeWidth: .9,
                                              )),
                                        )),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Microsoft',
                              style: GoogleFonts.ubuntu(color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                });
          }
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}