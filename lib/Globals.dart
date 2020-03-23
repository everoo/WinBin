import 'dart:async';
import 'package:Archive/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Archive/Create/create.dart';
import 'Home/HomePage.dart';
import 'Home/home.dart';

Timestamp currentDay = Timestamp.now();
ThemeData themeData = darkThemeData;
String myID = '';
ScrollController bgController = ScrollController(initialScrollOffset: 500);
String creationType = "Image";
Home home = Home();
CreateTab createTab = CreateTab();
HomeTab homeTab = HomeTab();
Background background = Background();
TabController tabController;
bool darkMode,
    askingDark,
    askingHand,
    vibrates,
    leftHanded,
    looping,
    nEULA,
    filtering;
bool authorizedUser = false;
int docNum = 0;
List<String> flaggedPosts, flaggedUsers, aFilters = [];
double width, height = 0;
Map medias = {};
bool sfw = true;
TextEditingController cont = TextEditingController();
List<int> numFilters = [0, 0, 0];

Future<void> lightImpact() async {
  if (vibrates) {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.lightImpact',
    );
  }
}

Future<void> heavyImpact() async {
  if (vibrates) {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.heavyImpact',
    );
  }
}

class ReadDecoration extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final double height;
  final Color borderColor;

  const ReadDecoration(
      {Key key, this.margin, this.child, this.height, this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: height,
      margin: margin ?? EdgeInsets.fromLTRB(8, 8, 8, 0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset.fromDirection(1, 3),
                color: Color(0x55000000),
                blurRadius: 2,
                spreadRadius: 2),
            BoxShadow(
                offset: Offset.zero,
                color: borderColor ?? Colors.transparent,
                blurRadius: 0,
                spreadRadius: 1)
          ],
          color: themeData.backgroundColor,
          borderRadius: BorderRadius.circular(25)),
      child: child,
    );
  }
}
