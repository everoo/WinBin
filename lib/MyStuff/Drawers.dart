import 'dart:async';
import 'dart:math';
import 'package:Archive/Home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Archive/Create/create.dart';
import 'package:Archive/Globals.dart';
import 'package:Archive/Home/HomePage.dart';
import 'package:Archive/MyStuff/DualIconButton.dart';
import 'package:Archive/main.dart';

class CreateDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          color: themeData.backgroundColor,
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                      color: n.value[1],
                      padding: EdgeInsets.fromLTRB(
                          40,
                          height * 0.23 / n.value[2],
                          40,
                          (height * 0.23 + 5) / n.value[2]),
                      child: Icon(
                        n.value[0],
                        size: 60,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        heavyImpact();
                        Navigator.of(context).pop();
                        sfw = true;
                        cont.clear();
                        creationType = n.key;
                        createTab = new CreateTab();
                        home.setState();
                      },
                      onLongPress: playTone,
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

double offset = 0;

class _HomeDrawerState extends State<HomeDrawer> {
  List<int> removedDays = [];
  List<int> allDays;
  FocusNode _focus = FocusNode();
  ScrollController homeCont =
      ScrollController(keepScrollOffset: true, initialScrollOffset: offset);

  @override
  void initState() {
    Duration dif = DateTime.now().difference(DateTime(2020, 3, 16));
    allDays = List<int>.generate(dif.inDays, (s) => s);
    homeCont.addListener(() {
      offset = homeCont.offset;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: themeData.backgroundColor,
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Container(
              height: height * 0.4,
              child: Center(
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    DualIconButton(
                      size: Size(width * 0.3, width * 0.3),
                      margin: EdgeInsets.fromLTRB(
                          (leftHanded) ? 0 : width * 0.45, height * 0.08, 0, 0),
                      icon: (askingDark)
                          ? Icon(
                              Icons.brightness_4,
                              color: themeData.colorScheme.onSecondary,
                              size: 60,
                            )
                          : Icon(
                              Icons.replay,
                              color: (looping ?? true)
                                  ? themeData.colorScheme.secondaryVariant
                                  : themeData.scaffoldBackgroundColor,
                              size: 60,
                            ),
                      action: (askingDark)
                          ? () {
                              lightImpact();
                              darkMode = !darkMode;
                              themeData =
                                  (darkMode) ? darkThemeData : lightThemeData;
                              SharedPreferences.getInstance().then((d) {
                                d.setBool('darkMode', darkMode);
                                setState(() {});
                                background = Background();
                                homeTab = HomeTab();
                                createTab = CreateTab();
                                home.setState();
                              });
                            }
                          : () {
                              lightImpact();
                              looping = !looping;
                              SharedPreferences.getInstance().then((d) {
                                d.setBool('looping', looping);
                                setState(() {});
                              });
                            },
                      actionA: () {
                        lightImpact();
                        askingDark = !askingDark;
                        SharedPreferences.getInstance().then((d) {
                          d.setBool('askingDark', askingDark);
                          setState(() {});
                        });
                      },
                    ),
                    Container(
                      height: width * 0.4,
                      width: width * 0.4,
                      margin: EdgeInsets.only(
                          top: height * 0.15,
                          left: (leftHanded) ? width * 0.3 : 10),
                      child: RaisedButton(
                        elevation: 9,
                        color: themeData.secondaryHeaderColor,
                        child: Icon(
                          Icons.search,
                          size: 100,
                          color: themeData.colorScheme.primary,
                        ),
                        onPressed: () {
                          heavyImpact();
                          if (_focus.hasFocus) {
                            _focus.unfocus();
                          } else {
                            _focus.requestFocus();
                          }
                        },
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return Dialog(
                                  backgroundColor: themeData.backgroundColor,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(14, 20, 14, 16),
                                    child: Text(
                                      'You can search for specific days\n Use a dot in place of a dash\nThe first day is 2020.01.29\n\nYYYY. returns all of that year\n.MM. returns all of that month\n..DD returns all of that day\n For Example:\n2020.02 gives all days in February 2020.\n.02.2 returns the days 20-29 of every February.\n2020..12 returns the 12th day of every month of 2020\n\nYou can go to a specific post by clicking on the number in the top left corner.',
                                      textAlign: TextAlign.center,
                                      style: themeData.textTheme.headline6,
                                    ),
                                  ),
                                );
                              });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    DualIconButton(
                      size: Size(width * 0.25, width * 0.25),
                      margin: EdgeInsets.fromLTRB(
                          (leftHanded) ? width * 0.28 : width * 0.215, 0, 0, 0),
                      icon: (askingHand)
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 3, right: 5),
                              child: Icon(Icons.pan_tool,
                                  size: 35, color: themeData.colorScheme.error),
                            )
                          : Icon(
                              Icons.vibration,
                              color: (vibrates ?? true)
                                  ? themeData.colorScheme.onPrimary
                                  : themeData.scaffoldBackgroundColor,
                              size: 35,
                            ),
                      action: (askingHand)
                          ? () {
                              leftHanded = !leftHanded;
                              SharedPreferences.getInstance().then((d) {
                                d.setBool('leftHanded', leftHanded);
                                Navigator.of(context).pop();
                                home.setState();
                              });
                            }
                          : () {
                              vibrates = !vibrates;
                              heavyImpact();
                              SharedPreferences.getInstance().then((d) {
                                d.setBool('vibrates', vibrates);
                                setState(() {});
                              });
                            },
                      actionA: () {
                        lightImpact();
                        askingHand = !askingHand;
                        SharedPreferences.getInstance().then((d) {
                          d.setBool('askingHand', askingHand);
                          setState(() {});
                        });
                      },
                    ),
                    Container(
                      height: width * 0.15,
                      width: width * 0.15,
                      margin: EdgeInsets.fromLTRB(
                          (leftHanded) ? width * 0.13 : width * 0.46,
                          height * 0.265,
                          0,
                          0),
                      child: RaisedButton(
                        color: themeData.secondaryHeaderColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 0.075)),
                        elevation: 9,
                        onPressed: () {
                          showDialog<Null>(
                            context: context,
                            builder: (con) {
                              return AlertDialog(
                                backgroundColor: themeData.backgroundColor,
                                content: Container(
                                  height: height * 0.5,
                                  width: width * 0.5,
                                  child: ListView(
                                    children: <Widget>[
                                      Text(
                                        'Contact Email:\nevercole6@gmail.com\n',
                                        textAlign: TextAlign.center,
                                        style: themeData.textTheme.headline6,
                                      ),
                                      Text(
                                        'EULA:\nYou will not post anythng that falls under these categories: Prolonged Graphic or Sadistic Realistic Violence, or Graphic Sexual Content and Nudity. And no gambling, simulated or otherwise is allowed. If you violate this agreement then your account, which is tied to your device, will be banned.\n',
                                        textAlign: TextAlign.center,
                                        style: themeData.textTheme.headline6,
                                      ),
                                      Text(
                                        'Most buttons can be held down to get more info.\n',
                                        textAlign: TextAlign.center,
                                        style: themeData.textTheme.headline6,
                                      ),
                                      Text(
                                        'Double tap a video/image to reorient it. You can pinch to zoom/move it around. Videos start looping(hold down the dark mode button to change this setting), but you can hold down a video to stop it.\n',
                                        textAlign: TextAlign.center,
                                        style: themeData.textTheme.headline6,
                                      ),
                                      Text(
                                        'Swipe left or right anywhere but the post to go to the next post.\n',
                                        textAlign: TextAlign.center,
                                        style: themeData.textTheme.headline6,
                                      ),
                                      Text(
                                        'Tap anywhere to exit a pop up like this. The button below filters NSFW content.\n',
                                        textAlign: TextAlign.center,
                                        style: themeData.textTheme.headline6,
                                      ),
                                      RaisedButton(
                                        color:
                                            themeData.scaffoldBackgroundColor,
                                        onPressed: () {
                                          filtering = !filtering;
                                          homeTab = HomeTab();
                                          SharedPreferences.getInstance().then(
                                            (value) {
                                              value.setBool(
                                                  'filtering', filtering);
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                        child: Text(
                                          (filtering)
                                              ? 'Stop Filtering'
                                              : 'Filter Content',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.info_outline,
                          color: themeData.colorScheme.onError,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: TextField(
                textAlign: TextAlign.center,
                onTap: () {
                  lightImpact();
                  if (_focus.hasFocus) {
                    _focus.unfocus();
                  } else {
                    _focus.requestFocus();
                  }
                },
                focusNode: _focus,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (t) {
                  bool ll = t.contains('..');
                  for (int n in allDays) {
                    if (!'${Timestamp.now().toDate().subtract(Duration(days: n))}'
                        .substring(0, 10)
                        .replaceRange(5, ll ? 7 : 5, '')
                        .replaceAll('-', '.')
                        .contains('$t')) {
                      if (!removedDays.contains(n)) {
                        removedDays.add(n);
                      }
                    } else {
                      removedDays.remove(n);
                    }
                  }
                  setState(() {});
                },
                style: themeData.textTheme.headline6,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: themeData.colorScheme.secondary)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: themeData.colorScheme.primaryVariant)),
                    contentPadding: EdgeInsets.all(8)),
                scrollPadding: EdgeInsets.all(0),
              ),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              margin: EdgeInsets.all(0),
            ),
            Container(
              height: height / 2,
              child: ListView(
                controller: homeCont,
                children: <Widget>[
                  for (int n in allDays)
                    (removedDays.contains(n))
                        ? Container()
                        : Container(
                            height: 50,
                            width: 250,
                            margin: EdgeInsets.fromLTRB(27, 6, 27, 6),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 9,
                              color: themeData.scaffoldBackgroundColor,
                              child: Text(
                                '${Timestamp.now().toDate().subtract(Duration(days: n)) ?? '2020-02-02'}'
                                    .substring(0, 10),
                                style: themeData.textTheme.headline6,
                              ),
                              onPressed:
                                  ('${Timestamp.now().toDate().subtract(Duration(days: n))}'
                                              .substring(0, 10) ==
                                          '${currentDay.toDate()}'
                                              .substring(0, 10))
                                      ? null
                                      : () {
                                          lightImpact();
                                          imageCache.clearLiveImages();
                                          docNum = 0;
                                          Navigator.of(context).pop();
                                          medias.forEach((key, value) {
                                            if (key.contains('videos')) {
                                              value.stop();
                                            } else if (key.contains('images')) {
                                              value.image.evict();
                                            }
                                          });
                                          medias = {};
                                          currentDay = Timestamp.fromDate(
                                              (DateTime.now().subtract(
                                                  Duration(days: n))));
                                          background = Background();
                                          homeTab = HomeTab();
                                          home.setState();
                                        },
                            ),
                          ),
                  Container(
                    height: 60,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<List<int>> tones = [
  List<int>.generate(30, (s) {
    int t = 0;
    List<int>.generate(s, (n) {
      t += min((1500 * pow(3 / 4, n)).toInt() + 6, 15);
      return n;
    });
    return t;
  }),
  List<int>.generate(28, (s) {
    int t = 0;
    List<int>.generate(s, (n) {
      t += (2000 * pow(3 / 4, 28 - n)).toInt() + 7;
      return n;
    });
    return t;
  }),
  [0, 360, 580, 760, 1150, 1938, 2299],
  [0, 114, 798, 912, 1729, 1843],
  List<int>.generate(20, (s) => s * 19),
  List<int>.generate(20, (s) => s * 19 + 1)
];
void playTone() {
  tones[Random().nextInt(6)].forEach((a) {
    Timer(Duration(milliseconds: a), () {
      if (a.gcd(19) == 1) {
        lightImpact();
      } else {
        heavyImpact();
      }
    });
  });
}
