import 'dart:math';

import 'package:flutter/material.dart';
import 'package:winbin/Globals.dart';
import 'package:winbin/Home/HomePage.dart';

class Home extends StatefulWidget {
  final _HomeState state = _HomeState();

  @override
  _HomeState createState() => state;

  void setState() {
    state.settState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  Background _background = Background();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
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
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Stack(
          children: <Widget>[
            _background,
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(35),
                child: Container(
                  color: themeData.hoverColor,
                  height: 16.0,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: themeData.colorScheme.error,
                    indicatorWeight: 20,
                    tabs: [
                      Tab(
                        child: Container(),
                      ),
                      Tab(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: (leftHanded)
                    ? [
                        create,
                        HomeTab(),
                      ]
                    : [
                        HomeTab(),
                        create,
                      ],
              ),
            ),
          ],
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
    int red = (Random().nextInt(128) + (darkMode ? 0 : 128)) * 65536;
    int blue = (Random().nextInt(128) + (darkMode ? 0 : 128)) * 256;
    int green = (Random().nextInt(96) + (darkMode ? 0 : 64));
    bgColor = Color(0xff000000 + red + blue + green);
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
