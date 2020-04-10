import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Globals.dart';

ThemeData lightThemeData = ThemeData(
    textTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
    backgroundColor: Color(0xFFEEEEEE),
    scaffoldBackgroundColor: Color(0xFFCDCDCD),
    secondaryHeaderColor: Color(0xFFA9A9A9),
    splashColor: Color(0xFFFF22FF),
    hoverColor: Color(0xFF553355),
    accentColor: Color(0xFFEEEEEE),
    bottomAppBarColor: Color(0xFFBEBEBE),
    colorScheme: ColorScheme(
      background: Color(0xFFFF00FF),
      brightness: Brightness.light,
      onBackground: Color(0xFFFF00FF),
      primary: Color(0xFFFF22FF),
      primaryVariant: Color(0xFFFF99FF),
      onPrimary: Color(0xFFFF99FF),
      secondary: Color(0xFFCC99CC),
      secondaryVariant: Color(0xFFDD33AA),
      onSecondary: Color(0xFFFF66FF),
      surface: Color(0xFF995599),
      onSurface: Color(0xFF995599),
      error: Color(0xFFBF00BF),
      onError: Color(0xFFBF00BF),
    ));
ThemeData darkThemeData = ThemeData(
  textTheme: TextTheme(headline6: TextStyle(color: Colors.grey[400])),
  backgroundColor: Color(0xFF262626),
  scaffoldBackgroundColor: Color(0xFF363636),
  secondaryHeaderColor: Color(0xFF202020),
  splashColor: Color(0xFF22DD22),
  hoverColor: Color(0xFF003300),
  accentColor: Color(0xFF292929),
  bottomAppBarColor: Color(0xFF050505),
  colorScheme: ColorScheme(
    background: Color(0xFF005555),
    brightness: Brightness.dark,
    onBackground: Color(0xFF00FF00),
    primary: Color(0xFF00AA99),
    primaryVariant: Color(0xFF006600),
    onPrimary: Color(0xFF449900),
    secondary: Color(0xFF338899),
    secondaryVariant: Color(0xFF005533),
    onSecondary: Color(0xFF22BBEE),
    surface: Color(0xFF668866),
    onSurface: Color(0xFF55BB88),
    error: Color(0xFF337799),
    onError: Color(0xFF23FF23),
  ),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    SharedPreferences.getInstance().then((shared) {
      myID = shared.getString('myID') ?? null;
      _getId();
      docNum = shared.getInt('$currentDay'.substring(0, 10)) ?? 0;
      flaggedUsers = shared.getStringList('flaggedUsers') ?? [];
      flaggedPosts = shared.getStringList('flaggedPosts') ?? [];
      aFilters = shared.getStringList('filters') ?? [];
      darkMode = shared.getBool('darkMode') ?? true;
      leftHanded = shared.getBool('leftHanded') ?? true;
      looping = shared.getBool('looping') ?? true;
      vibrates = shared.getBool('vibrates') ?? true;
      nEULA = shared.getBool('nEULA') ?? true;
      filtering = shared.getBool('filtering') ?? false;
      creationType = shared.getString('creationType') ?? 'Image';
      if (darkMode) {
        themeData = darkThemeData;
      } else {
        themeData = lightThemeData;
      }
      runApp(MyApp());
    });
  });
}

String returnable = '';
Future _getId() async {
  if (myID == null) {
    createAccount();
  } else {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: '$myID@archive.io', password: 'aVerySecurePassword')
        .catchError((err) {
      if ('$err'.contains('USER_NOT_FOUND')) {
        createAccount();
      }
    });
    await Firestore.instance
        .collection('0000auth')
        .document('all')
        .get()
        .then((value) {
      if (value.data['names'].contains(myID)) {
        authorizedUser = true;
      }
    });
  }
}

Future createAccount() async {
  int rando = Random().nextInt(36);
  returnable = returnable +
      'abcdefghijklmnopqrstuvwxyz0123456789'.substring(rando, rando + 1);
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: '$returnable@archive.io', password: 'aVerySecurePassword')
      .catchError((err) {
    if ('$err'.contains('EMAIL_ALREADY_IN_USE')) {
      createAccount();
    }
  }).whenComplete(() async {
    myID = returnable;
    await SharedPreferences.getInstance()
        .then((value) => value.setString('myID', myID));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: (darkMode) ? ThemeMode.dark : ThemeMode.light,
      darkTheme: darkThemeData,
      theme: lightThemeData,
      debugShowCheckedModeBanner: false,
      title: "Archive",
      home: home,
    );
  }
}
