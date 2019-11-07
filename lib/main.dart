import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winbin/signIn.dart';

String currentUsersName = '';
FirebaseUser currentUser;
ThemeMode themeMode;
ThemeData themeData;
bool darkMode = false;
ScrollController bgController = ScrollController(initialScrollOffset: 150);

List<ScrollController> scrollers = [
  ScrollController(),
  ScrollController(),
  ScrollController()
];
ThemeData lightThemeData = ThemeData(
    textTheme: TextTheme(title: TextStyle(color: Colors.black)),
    backgroundColor: Color(0xFFEEEEEE),
    scaffoldBackgroundColor: Color(0xFFBABABA),
    secondaryHeaderColor: Color(0xFFA9A9A9),
    splashColor: Color(0xFFFF22FF),
    hoverColor: Color(0xFFDDBBDD),
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
  secondaryHeaderColor: Color(0xFF303030),
  splashColor: Color(0xFF22DD22),
  hoverColor: Color(0xFFDDBBDD),
  accentColor: Color(0xFF292929),
  colorScheme: ColorScheme(
    background: Color(0xFF008888),
    brightness: Brightness.dark,
    onBackground: Color(0xFF00FF00),
    primary: Color(0xFF00AA99), //
    primaryVariant: Color(0xFF006600), //
    onPrimary: Color(0xFF00EE00),
    secondary: Color(0xFF338899), //
    secondaryVariant: Color(0xFF005533), //
    onSecondary: Color(0xFF22BBEE), //
    surface: Color(0xFF668866), //
    onSurface: Color(0xFF668866),
    error: Color(0xDD337799), //
    onError: Color(0xDD23FF23),
  ),
);

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    SharedPreferences.getInstance().then((loopy) {
      bool darkMo = loopy.getBool('darkMode');
      if (darkMo == null) {
        loopy.setBool('darkMode', true);
        darkMode = true;
      }
      darkMode = darkMo;
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: themeMode,
      darkTheme: themeData,
      theme: themeData,
      debugShowCheckedModeBanner: false,
      title: "winbin",
      home: LoginPage(true),
    );
  }
}
