import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jazia/auth/auth.dart';
import 'package:jazia/chatfiles/chatpage.dart';
import 'package:jazia/chatfiles/chatrequest.dart';
import 'package:jazia/services/app_theme.dart';
import 'package:jazia/services/constants.dart';
import 'package:jazia/services/theme_notifier.dart';
import 'package:jazia/trydart/landorder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Smsfunctions/GetMessages.dart';
import 'firebase_options.dart';

ThemeNotifier? themeNotifier;
SharedPreferences? prefs;
String? themeMode;
IconData? iconData = Icons.brightness_7;
void onThemeChanged(String value) async {
  prefs = await SharedPreferences.getInstance();

  if (value == Constants.SYSTEM_DEFAULT) {
    themeNotifier?.setThemeMode(ThemeMode.system);
  } else if (value == Constants.DARK) {
    themeNotifier?.setThemeMode(ThemeMode.dark);
  } else {
    themeNotifier?.setThemeMode(ThemeMode.light);
  }
  prefs?.setString(Constants.APP_THEME, value);
}

getTheme() async {
  var prefs = await SharedPreferences.getInstance();
  themeMode = prefs.getString(Constants.APP_THEME);

  onThemeChanged(themeMode == 'Dark' ? 'light' : 'Dark');
  themeMode == 'Dark'
      ? iconData = Icons.brightness_3_sharp
      : iconData = Icons.brightness_7;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((value) {
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (BuildContext context) {
          String? theme = value.getString(Constants.APP_THEME);
          if (theme == null ||
              theme == "" ||
              theme == Constants.SYSTEM_DEFAULT) {
            value.setString(Constants.APP_THEME, Constants.SYSTEM_DEFAULT);
            return ThemeNotifier(ThemeMode.system);
          }
          return ThemeNotifier(
              theme == Constants.DARK ? ThemeMode.dark : ThemeMode.light);
        },
        child: MyApp(),
      ),
    );
  });

  // runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var deviceData = <String, dynamic>{};
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    print("the fingerprint id is ${deviceFingerprint.toString()}");
    return MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme().lightTheme,
        darkTheme: AppTheme().darkTheme,
        themeMode: themeNotifier.getThemeMode(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/landorder': (context) => const LandOrder(),
          '/chatrequests': (context) => const ChatReq(),
        },
        //home: const ChatReq(),
        home: AuthService().handleAuth() //const LandExisting(),
        //home:  const LandOrder(),

        );
  }
}

///TODO: GET VALUE FROM TEXTFIELDS RECORD TO UPLOAD CODE ALONSIDE URL AND UPLOAD
///TODO: STREAM THE VALUES FROM DB WITH UI
///TODO: CREATE TEXT AND RECIEVE ON OTHER END FUNCTIONALITY