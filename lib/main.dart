import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winbin/Home/home.dart';

import 'Globals.dart';

ThemeData lightThemeData = ThemeData(
    textTheme: TextTheme(title: TextStyle(color: Colors.black)),
    backgroundColor: Color(0xFFEEEEEE),
    scaffoldBackgroundColor: Color(0xFFBABABA),
    secondaryHeaderColor: Color(0xFFA9A9A9),
    splashColor: Color(0xFFFF22FF),
    hoverColor: Color(0xFF553355),
    accentColor: Color(0xFFEEEEEE),
    colorScheme: ColorScheme(
      background: Color(0xFFFF00FF), //
      brightness: Brightness.light,
      onBackground: Color(0xFFFF00FF),
      primary: Color(0xFFFF22FF), //
      primaryVariant: Color(0xFFFF99FF), //
      onPrimary: Color(0xFFFF99FF),
      secondary: Color(0xFFCC99CC), //
      secondaryVariant: Color(0xFFFFCCFF), //
      onSecondary: Color(0xFFFFCCFF),
      surface: Color(0xFF995599), //
      onSurface: Color(0xFF995599),
      error: Color(0xDDBF00BF), //
      onError: Color(0xDDBF00BF),
    ));
ThemeData darkThemeData = ThemeData(
  textTheme: TextTheme(title: TextStyle(color: Colors.grey[400])),
  backgroundColor: Color(0xFF262626),
  scaffoldBackgroundColor: Color(0xFF464646),
  secondaryHeaderColor: Color(0xFF202020),
  splashColor: Color(0xFF22DD22),
  hoverColor: Color(0xFF003300),
  accentColor: Color(0xFF292929),
  colorScheme: ColorScheme(
    background: Color(0xFF008888),
    brightness: Brightness.dark,
    onBackground: Color(0xFF00FF00),
    primary: Color(0xFF00AA99), //
    primaryVariant: Color(0xFF006600), //
    onPrimary: Color(0xFF003300),
    secondary: Color(0xFF338899), //
    secondaryVariant: Color(0xFF005533), //
    onSecondary: Color(0xFF22BBEE), //
    surface: Color(0xFF668866), //
    onSurface: Color(0xFF55BB88),
    error: Color(0xDD337799), //
    onError: Color(0xDD23FF23),
  ),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    SharedPreferences.getInstance().then((shared) {
      darkMode = shared.getBool('darkMode') ?? true;
      leftHanded = shared.getBool('leftHanded') ?? true;
      looping = shared.getBool('looping') ?? true;
      if (darkMode) {
        themeMode = ThemeMode.dark;
        themeData = darkThemeData;
      } else {
        themeMode = ThemeMode.light;
        themeData = lightThemeData;
      }
      runApp(MyApp());
    });
  });
}

Map<String, Stream<DocumentSnapshot>> streams = {
  'A': null,
  'B': null,
  'C': null,
  'D': null
};
Map<String, Stream<DocumentSnapshot>> currentStream = {};
Map<String, Stream<DocumentSnapshot>> streamA = {};
Map<String, Stream<DocumentSnapshot>> streamB = {};
Map<String, Stream<DocumentSnapshot>> streamC = {};
Map<String, Stream<DocumentSnapshot>> streamD = {};

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: themeMode,
      darkTheme: themeData,
      theme: themeData,
      debugShowCheckedModeBanner: false,
      title: "WinBin",
      home: home = Home(),
    );
  }
}
