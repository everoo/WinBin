import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Create/create.dart';
import 'Home/home.dart';

ThemeMode themeMode;
ThemeData themeData;
bool darkMode = false;
bool leftHanded = false;
bool looping = true;
String myID;
ScrollController bgController = ScrollController(initialScrollOffset: 500);
String creationType = "Video";
Home home;
CreateTab create = CreateTab();
String currentBoard = 'A';
GlobalKey<ScaffoldState> homeDrawerKey = GlobalKey();
List<String> urlStream = [];

Future<void> lightImpact() async {
  await SystemChannels.platform.invokeMethod<void>(
    'HapticFeedback.vibrate',
    'HapticFeedbackType.lightImpact',
  );
}

Future<void> vibrate() async {
  await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
}

Future<void> heavyImpact() async {
  await SystemChannels.platform.invokeMethod<void>(
    'HapticFeedback.vibrate',
    'HapticFeedbackType.heavyImpact',
  );
}

class ReadDecoration extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final double height;

  const ReadDecoration({Key key, this.margin, this.child, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? EdgeInsets.fromLTRB(8, 8, 8, 0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset.fromDirection(1, 3),
                color: Color(0x55000000),
                blurRadius: 2,
                spreadRadius: 2)
          ],
          color: themeData.backgroundColor,
          borderRadius: BorderRadius.circular(25)),
      child: child,
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final String message;
  ErrorMessage(this.message);
  @override
  Widget build(BuildContext context) {
    return ReadDecoration(
      height: 50,
      child: Center(
        child: Text(
          'this didnt load properly\n$message',
          style: themeData.textTheme.title,
        ),
      ),
    );
  }
}
