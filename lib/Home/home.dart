import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final _HomeState state = _HomeState();

  @override
  _HomeState createState() => state;

  void setState() => state.settState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    tabController = TabController(
        vsync: this, length: 2, initialIndex: (leftHanded) ? 1 : 0);
  }

  @override
  void dispose() {
    imageCache.clear();
    imageCache.clearLiveImages();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pads = MediaQuery.of(context).padding;
    width = MediaQuery.of(context).size.width - pads.left - pads.right;
    height = MediaQuery.of(context).size.height - pads.top - pads.bottom;
    if (nEULA) {
      showingIndicator = true;
      Timer(Duration(milliseconds: 300), () async {
        await showDialog<Null>(
            barrierDismissible: false,
            builder: (c) {
              return AlertDialog(
                backgroundColor: themeData.backgroundColor,
                title: Text('End User License Agreement',
                    textAlign: TextAlign.center),
                content: Text(
                  'You will not post anything that falls under these categories: Prolonged Graphic or Sadistic Realistic Violence, or Graphic Sexual Content and Nudity. And no gambling, simulated or otherwise is allowed. If you violate this agreement then your account, which is tied to your device, will be banned.\n\nContact evercole6@gmail.com for all questions.',
                  style: themeData.textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                actionsPadding: EdgeInsets.fromLTRB(0, 0, width * 0.22, 0),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        nEULA = false;
                        SharedPreferences.getInstance()
                          ..then((value) => value.setBool('nEULA', false));
                      },
                      child: Text(
                        'Agree To EULA',
                        style: themeData.textTheme.headline6,
                      ))
                ],
              );
            },
            context: context);
        await Future.delayed(Duration(milliseconds: 600))
            .then((value) => homeDrawerKey.currentState.openEndDrawer());
        await Future.delayed(Duration(milliseconds: 1000))
            .then((value) => Navigator.of(context).pop());
        await Future.delayed(Duration(milliseconds: 500))
            .then((value) => tabController.animateTo(0));
        await Future.delayed(Duration(milliseconds: 300))
            .then((value) => createDrawerKey.currentState.openDrawer());
        await Future.delayed(Duration(milliseconds: 700))
            .then((value) => Navigator.of(context).pop());
        await Future.delayed(Duration(milliseconds: 500))
            .then((value) => tabController.animateTo(1));
      });
    }
    return Padding(
      padding: pads,
      child: Scaffold(
        backgroundColor: themeData.bottomAppBarColor,
        body: TabBarView(
          controller: tabController,
          children: (leftHanded) ? [createTab, homeTab] : [homeTab, createTab],
        ),
      ),
    );
  }

  void settState() {
    if (mounted) {
      setState(() {});
    }
  }
}
