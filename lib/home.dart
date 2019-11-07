import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Create/create.dart';
import 'package:winbin/HomePage.dart';
import 'package:winbin/main.dart';
import 'package:winbin/profile.dart';

class Home extends StatefulWidget {
  final FirebaseUser user;

  const Home({
    Key key,
    this.user,
  }) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  Background _background = Background();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(listener);
  }

  double leftMargin = 100;
  double rightMargin = 100;

  void listener() {
    if (_tabController.index == 1 || _tabController.index == 2) {
      //FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Stack(
          children: <Widget>[
            _background,
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: Container(
                  color: themeData.colorScheme.surface,
                  height: 100.0,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: themeData.colorScheme.primary,
                    indicatorWeight: 5,
                    tabs: [
                      Tab(
                          child: Container(
                        child: Icon(
                          Icons.add_circle,
                          color: themeData.colorScheme.primaryVariant,
                        ),
                        padding: EdgeInsets.only(top: 15),
                      )),
                      Tab(
                          child: Container(
                        child: Icon(
                          Icons.home,
                          color: themeData.colorScheme.primaryVariant,
                        ),
                        padding: EdgeInsets.only(top: 15),
                      )),
                      Tab(
                          child: Container(
                        child: Icon(
                          Icons.account_circle,
                          color: themeData.colorScheme.primaryVariant,
                        ),
                        padding: EdgeInsets.only(top: 15),
                      )),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  CreateTab(),
                  HomeTab(),
                  ProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Background extends StatefulWidget {
  final _BackgroundState state = _BackgroundState();
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  int imageInt = 0;
  Color bgColor = Colors.transparent;
  double left = 0;
  double right = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    imageInt = Random().nextInt(3);
    int red = (Random().nextInt(128)+(darkMode?0:128)) * 65536;
    int blue = (Random().nextInt(128)+(darkMode?0:128)) * 256;
    int green = (Random().nextInt(96)+(darkMode?0:64));
    bgColor = Color(0xff000000+red+blue+green);
  }

  @override
  Widget build(BuildContext context) {
    init();
    return SingleChildScrollView(
      controller: bgController,
      child: Container(
        color: bgColor,
        //foregroundDecoration: BoxDecoration(color: bgColor),
        height: 25000,
        child: Image(
            alignment: Alignment(50, 0),
            image: AssetImage('assets/imaa/bgtex$imageInt.png'),
            repeat: ImageRepeat.repeat),
      ),
    );
  }
}
