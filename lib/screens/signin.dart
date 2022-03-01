// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../services/theme_notifier.dart';
import '../widgets/frostyglass.dart';
import '../widgets/signin_buttons.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  List<Color> colors = [Colors.amber, Colors.red, Colors.pink];
  List<double> stops = [0.0, 0.5, 1.0];
  late Timer _timer;

  changeBG() {
    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        for (int i = 0; i < colors.length; i++) {
          setState(() {
            final random = Random();
            colors[i] = Color.fromRGBO(random.nextInt(254), random.nextInt(254),
                random.nextInt(254), 1);
          });
        }
      });
    }
  }

  @override
  void initState() {
    changeBG();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: .0,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: AnimatedContainer(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors[0], colors[1], colors[2]],
                  stops: stops)),
          duration: Duration(milliseconds: 3000),
          child: Stack(
            children: [
              FrostedGlassBox(
                width: size.width,
                height: size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.arrow_down_doc),
                        SizedBox(
                          width: 5,
                        ),
                        Text('JAZIA',
                            style: GoogleFonts.montserrat(
                                color: Colors.blueGrey,
                                fontSize: 35,
                                letterSpacing: 2))
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Text('Welcome',
                        style: GoogleFonts.ubuntu(
                            color: Colors.black, fontSize: 25)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Sign up for free',
                      style: GoogleFonts.ubuntu(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      indent: size.width / 3,
                      endIndent: size.width / 3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SigninButtons()
                  ],
                ),
              ),
              IconButton(onPressed: () => getTheme(), icon: Icon(iconData)),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Text('jazia© pre-release',
                      style: GoogleFonts.ubuntu(fontSize: 8))),
            ],
          ),
        ),
      ),
    );
  }
}