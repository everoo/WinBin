import 'dart:async';
import 'dart:io';
import 'package:Archive/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Archive/Create/create.dart';
import 'Home/HomePage.dart';
import 'Home/home.dart';

DateTime currentDay = DateTime.now().toUtc();
ThemeData themeData = darkThemeData;
String myID = '';
String creationType = "Image";
Home home = Home();
CreateTab createTab = CreateTab();
GlobalKey<ScaffoldState> homeDrawerKey = GlobalKey();
GlobalKey<ScaffoldState> createDrawerKey = GlobalKey();
File file;
HomeTab homeTab = HomeTab();
TabController tabController;
TextEditingController replyController = TextEditingController();
bool darkMode, vibrates, leftHanded, looping, nEULA, filtering;
bool authorizedUser = false;
bool showingIndicator = false;
int docNum = 0;
List<String> flaggedPosts, flaggedUsers, aFilters = [];
double width, height = 0;
EdgeInsets pads;
Map medias = {};
bool sfw = true;
TextEditingController cont = TextEditingController();
List<int> numFilters = [0, 0, 0];
double way = 0;

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
      child: child ?? Container(),
    );
  }
}
