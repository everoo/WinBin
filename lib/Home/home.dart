import 'dart:async';
import 'dart:math';
import 'package:firebase_admob/firebase_admob.dart';
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

ScrollController bgTW = ScrollController();

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      myBanner.dispose();
      if (((leftHanded) ? 1 : 0) == tabController.index) {
        myBanner =
            BannerAd(adUnitId: BannerAd.testAdUnitId, size: AdSize.fullBanner)
              ..load()
              ..show();
      } else {
        myBanner =
            BannerAd(adUnitId: BannerAd.testAdUnitId, size: AdSize.fullBanner);
      }
    });
    tabController.animation.addListener(() {
      bgTW.jumpTo(tabController.animation.value * width * 0.5);
    });
  }

  BannerAd myBanner =
      BannerAd(adUnitId: BannerAd.testAdUnitId, size: AdSize.fullBanner);

  @override
  void dispose() {
    imageCache.clear();
    imageCache.clearLiveImages();
    super.dispose();
    myBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (((leftHanded) ? 1 : 0) == tabController.index) {
      myBanner
        ..load()
        ..show();
    }
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (nEULA) {
      Timer(Duration(milliseconds: 300), () {
        showDialog<Null>(
            barrierDismissible: false,
            builder: (c) {
              return AlertDialog(
                backgroundColor: themeData.backgroundColor,
                title: Text(
                  'End User License Agreement',
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  'A hint is that most buttons can be held down, also both sides have a drawer.(swipe from the left to the right when on the left side, and vice-versa.)\n\n You will not post anything that falls under these categories: Prolonged Graphic or Sadistic Realistic Violence, or Graphic Sexual Content and Nudity. And no gambling, simulated or otherwise is allowed. If you violate this agreement then your account, which is tied to your device, will be banned.\n\nContact evercole6@gmail.com for all questions.',
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
      });
    }
    return DefaultTabController(
      initialIndex: (leftHanded) ? 0 : 0,
      length: 2,
      child: Stack(
        children: <Widget>[
          background,
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(height / 35),
              child: Container(
                color: themeData.hoverColor,
                height: height / 35,
                child: TabBar(
                  controller: tabController,
                  indicatorColor: themeData.colorScheme.background,
                  indicatorWeight: height / 35,
                  tabs: [Tab(child: Container()), Tab(child: Container())],
                ),
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children:
                  (leftHanded) ? [createTab, homeTab] : [homeTab, createTab],
            ),
          ),
        ],
      ),
    );
  }

  void settState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }
}

class Background extends StatefulWidget {
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    int red = (Random().nextInt(128) + (darkMode ? 0 : 128)) * 65536;
    int blue = (Random().nextInt(128) + (darkMode ? 0 : 128)) * 256;
    int green = (Random().nextInt(96) + (darkMode ? 0 : 64));
    return IgnorePointer(
      child: SingleChildScrollView(
        controller: bgTW,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
            controller: bgController,
            child: Container(
                color: Color(0xff000000 + red + blue + green),
                height: 25000,
                width: width * 1.5,
                child: Image(
                    image: AssetImage(
                        'assets/imaa/bgtex${Random().nextInt(4)}.png'),
                    repeat: ImageRepeat.repeat))),
      ),
    );
  }
}
