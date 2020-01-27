import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winbin/Globals.dart';
import 'package:winbin/main.dart';

import 'CustomSwitch.dart';////

class CreateDrawer extends StatefulWidget {
  @override
  _CreateDrawerState createState() => _CreateDrawerState();
}

class _CreateDrawerState extends State<CreateDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          color: themeData.colorScheme.background,
          child: Center(
            child: Wrap(
              children: <Widget>[
                for (var n in {
                  'Image': [
                    Icons.image,
                    themeData.colorScheme.secondaryVariant,
                    1
                  ],
                  'Video': [
                    Icons.play_circle_filled,
                    themeData.colorScheme.secondary,
                    1
                  ],
                  'Story': [
                    Icons.import_contacts,
                    themeData.colorScheme.primaryVariant,
                    1.618
                  ],
                  'Poll': [Icons.poll, themeData.colorScheme.primary, 1.618]
                }.entries)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: RaisedButton(
                      elevation: 4,
                      color: n.value[1],
                      padding: EdgeInsets.fromLTRB(
                          40, 153 / n.value[2], 40, 158 / n.value[2]),
                      child: Icon(
                        n.value[0],
                        size: 60,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        heavyImpact();
                        Navigator.of(context).pop();
                        creationType = n.key;
                        create.setState();
                      },
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: themeData.backgroundColor,
        child: Column(
          children: <Widget>[
            for (String board in ['A', 'B', 'C', 'D'])
              Container(
                height: 50,
                width: 250,
                margin: EdgeInsets.fromLTRB(27, 15, 27, 0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 9,
                  color: themeData.scaffoldBackgroundColor,
                  child: Text(board),
                  onPressed: (currentBoard != board)
                      ? () {
                          lightImpact();
                          currentBoard = board;
                          Navigator.of(context).pop();
                          currentStream = {};
                          home.setState();
                          SharedPreferences.getInstance().then((d) {
                            d.setString('currentBoard', board);
                          });
                        }
                      : null,
                ),
              ),
            Container(
              padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSwitch(),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(27.5, 0, 27.5, 12),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset.fromDirection(1, 2),
                        color: Color(0x55000000),
                        blurRadius: 2,
                        spreadRadius: 2)
                  ],
                  color: themeData.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(30)),
              width: 250,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 124,
                    child: FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(left: 44),
                        child: Transform(
                          child: Icon(
                            Icons.pan_tool,
                            color: (leftHanded)
                                ? themeData.textTheme.title.color
                                : themeData.splashColor,
                          ),
                          transform: Matrix4.rotationY(3.14),
                        ),
                      ),
                      onPressed: () async {
                        lightImpact();
                        if (leftHanded) {
                          leftHanded = false;
                          await SharedPreferences.getInstance().then((sp) {
                            sp.setBool('leftHanded', false);
                          });
                          Navigator.of(context).pop();
                          home.setState();
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 60,
                    width: 124,
                    child: FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Icon(
                        Icons.pan_tool,
                        color: (leftHanded)
                            ? themeData.splashColor
                            : themeData.textTheme.title.color,
                      ),
                      onPressed: () async {
                        lightImpact();
                        leftHanded = true;
                        Navigator.of(context).pop();
                        home.setState();
                        await SharedPreferences.getInstance().then((sp) {
                          sp.setBool('leftHanded', true);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 200,
                width: 200,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 150,
                      width: 150,
                      margin:
                          EdgeInsets.only(top: 50, left: (leftHanded) ? 50 : 0),
                      child: RaisedButton(
                        elevation: 9,
                        splashColor: Color(0xFFAA0000),
                        highlightColor: Color(0xFFFF0000),
                        color: Color(0xFFCC0000),
                        onPressed: () {
                          heavyImpact();
                        },
                        onLongPress: () {
                          playTone([
                            0,
                            1000,
                            1750,
                            2312,
                            2732,
                            3047,
                            3282,
                            3457,
                            3587,
                            3684,
                            3756,
                            3810,
                            3850,
                            3880,
                            3900
                          ]);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    Container(
                      height: 75,
                      width: 75,
                      margin:
                          EdgeInsets.fromLTRB((leftHanded) ? 0 : 125, 0, 0, 0),
                      child: RaisedButton(
                        elevation: 9,
                        splashColor: Color(0xFFAA0000),
                        highlightColor: Color(0xFFFF0000),
                        color: Color(0xFFCC0000),
                        onPressed: () {
                          lightImpact();
                        },
                        onLongPress: () {
                          playTone([0, 360, 580, 750, 1150, 1940, 2290]);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(37.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void playTone(List<int> tone) {
    tone.forEach((a) {
      Timer(Duration(milliseconds: a), () {
        heavyImpact();
      });
    });
  }
}

class LightCue extends StatelessWidget {
  bool left = false;
  LightCue(this.left);

  @override
  Widget build(BuildContext context) {
    if (left) {
      return Container(
        height: 650,
        width: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              themeData.colorScheme.background.withAlpha(75),
              themeData.colorScheme.background.withAlpha(0),
            ],
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(left: 325),
        height: 650,
        width: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              themeData.colorScheme.background.withAlpha(75),
              themeData.colorScheme.background.withAlpha(0),
            ], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
      );
    }
  }
}
