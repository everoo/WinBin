import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Archive/Create/create.dart';
import 'package:Archive/Globals.dart';
import 'package:Archive/Home/HomePage.dart';
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
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 9,
                      color: n.value[1],
                      padding: EdgeInsets.fromLTRB(
                          40,
                          height * 0.235 / n.value[2],
                          40,
                          (height * 0.235 + 5) / n.value[2]),
                      child: Icon(
                        n.value[0],
                        size: 60,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        heavyImpact();
                        Navigator.of(context).pop();
                        sfw = true;
                        if (file != null) file.delete().catchError((e) {});
                        file = null;
                        cont.clear();
                        creationType = n.key;
                        SharedPreferences.getInstance().then((value) =>
                            value.setString('creationType', creationType));
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
bool askingInfo = true;

class _HomeDrawerState extends State<HomeDrawer> {
  List<int> removedDays = [];
  List<int> allDays;
  FocusNode _focus = FocusNode();
  ScrollController homeCont =
      ScrollController(keepScrollOffset: true, initialScrollOffset: offset);
  Widget _ic;

  @override
  void initState() {
    Duration dif = DateTime.now().toUtc().difference(DateTime(2020, 3, 20));
    allDays = List<int>.generate(dif.inDays, (s) => s);
    homeCont.addListener(() {
      offset = homeCont.offset;
    });
    super.initState();
    loopTime();
    _ic = IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (c) {
              return Dialog(
                backgroundColor: themeData.backgroundColor,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(14, 20, 14, 16),
                  child: Text(
                    'You can search for specific days.\n Use a dot in place of a dash.\nThe first day is 2020.03.21\n\nYYYY. returns all of that year\n.MM. returns all of that month\n..DD returns all of that day\n\n For Example:\n\n2020.05 returns all days in May 2020.\n\n.05.2 returns the 20-29th of every May.\n\n2020..12 returns the 12th day of every month of 2020.\n',
                    textAlign: TextAlign.center,
                    style: themeData.textTheme.headline6,
                  ),
                ),
              );
            });
      },
      color: themeData.colorScheme.onSurface,
      icon: Icon(Icons.help_outline),
    );
  }

  //potential things to add:
  //more than one answer on polls
  //make scale animation when zooming on images and videos as well

  DateTime tomorrow = DateTime(DateTime.now().toUtc().year,
      DateTime.now().toUtc().month, DateTime.now().toUtc().day + 1);
  String _timer = 'll';
  loopTime() {
    _timer =
        '${tomorrow.difference(DateTime.now().toUtc()) + DateTime.now().timeZoneOffset}'
            .split('.')
            .first;
    if (_timer.startsWith('0:')) _timer = _timer.substring(2, _timer.length);
    setState(() {});
    Timer(Duration(seconds: 1), loopTime);
  }

  @override
  Widget build(BuildContext context) {
    List<IconData> ico = [
      Icons.account_circle,
      Icons.vibration,
      Icons.pan_tool,
      Icons.replay,
      Icons.brightness_4,
      Icons.info_outline,
    ];
    List<String> tex = [
      'Unblock People',
      'Toggle Vibrations',
      'Toggle Right Handed',
      'Toggle Video Looping',
      'Toggle Dark Mode',
      'Show Info',
    ];
    List<VoidCallback> act = [
      clearPreferences,
      switchVibrations,
      switchSides,
      switchLooping,
      switchColor,
      showInfo
    ];
    List<Color> col = [
      themeData.colorScheme.primary,
      (vibrates)
          ? themeData.colorScheme.onPrimary
          : themeData.scaffoldBackgroundColor,
      themeData.colorScheme.error,
      (looping)
          ? themeData.colorScheme.secondaryVariant
          : themeData.scaffoldBackgroundColor,
      themeData.colorScheme.onSecondary,
      themeData.colorScheme.onError
    ];
    if (leftHanded) {
      col = col.reversed.toList();
      act = act.reversed.toList();
      tex = tex.reversed.toList();
      ico = ico.reversed.toList();
    }
    return Drawer(
      child: Container(
        color: themeData.backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
              child: Text(
                'Next Day In\n$_timer',
                textAlign: TextAlign.center,
                style: themeData.textTheme.headline6,
              ),
            ),
            Container(
              height: 1,
              color: themeData.colorScheme.primary,
              margin: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
            ),
            Container(
              height: height * ((_focus.hasFocus) ? 0.43 : 0.76),
              child: ListView(
                padding: EdgeInsets.zero,
                reverse: true,
                controller: homeCont,
                children: <Widget>[
                  for (int n in allDays)
                    (removedDays.contains(n)) ? Container() : DatePicker(n)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextField(
                textAlign: TextAlign.center,
                onTap: () {
                  lightImpact();
                  setState(() {
                    if (_focus.hasFocus) {
                      _focus.unfocus();
                    } else {
                      _focus.requestFocus();
                    }
                  });
                },
                focusNode: _focus,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (t) {
                  bool ll = t.contains('..');
                  for (int n in allDays) {
                    if (!'${DateTime.now().toUtc().subtract(Duration(days: n))}'
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
                    prefixIcon: (leftHanded) ? null : _ic,
                    suffixIcon: (leftHanded) ? _ic : null,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: themeData.colorScheme.secondary)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: themeData.colorScheme.primaryVariant)),
                    contentPadding: EdgeInsets.all(8)),
                scrollPadding: EdgeInsets.all(0),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: width * 0.02),
              height: height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  for (int n in List.generate(6, (i) => i))
                    IconButton(
                      tooltip: tex[n],
                      icon: Icon(ico[n]),
                      onPressed: act[n],
                      color: col[n],
                      iconSize: width * 0.08,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  switchColor() {
    lightImpact();
    way = 0;
    darkMode = !darkMode;
    themeData = (darkMode) ? darkThemeData : lightThemeData;
    SharedPreferences.getInstance().then((d) {
      d.setBool('darkMode', darkMode);
      setState(() {});
      homeTab = HomeTab();
      createTab = CreateTab();
      home.setState();
    });
  }

  switchLooping() {
    lightImpact();
    looping = !looping;
    SharedPreferences.getInstance().then((d) {
      d.setBool('looping', looping);
      setState(() {});
    });
  }

  switchSides() {
    way = 0;
    leftHanded = !leftHanded;
    SharedPreferences.getInstance().then((d) {
      d.setBool('leftHanded', leftHanded);
      Navigator.of(context).pop();
      home.setState();
      tabController.animateTo((leftHanded) ? 1 : 0);
      Timer(Duration(milliseconds: 250), () {
        if (leftHanded) {
          homeDrawerKey.currentState.openEndDrawer();
        } else {
          homeDrawerKey.currentState.openDrawer();
        }
      });
    });
  }

  switchVibrations() {
    vibrates = !vibrates;
    heavyImpact();
    SharedPreferences.getInstance().then((d) {
      d.setBool('vibrates', vibrates);
      setState(() {});
    });
  }

  clearPreferences() {
    heavyImpact();
    SharedPreferences.getInstance().then((d) {
      d.setStringList('flaggedUsers', []);
      d.setStringList('flaggedPosts', []);
      setState(() => askingInfo = !askingInfo);
      flaggedPosts = [];
      flaggedUsers = [];
      homeTab = HomeTab();
      home.setState();
    });
  }

  showInfo() {
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
                  'Most buttons can be held down to get more info.\n',
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.headline6,
                ),
                Text(
                  'Double tap a video/image to reorient it. You can pinch to zoom/move it around. Videos start ${(looping) ? '' : 'not '}looping, but you can hold down a video to change it.\n',
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.headline6,
                ),
                Text(
                  'Swipe left or right anywhere but a post to go to the next or previous post.\n',
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.headline6,
                ),
                Text(
                  'Inorder to dismiss a keyboard just retap on whatever activated the keyboard.\n',
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.headline6,
                ),
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
                  'Tap anywhere to exit a pop up like this. The button below filters NSFW content.\n',
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.headline6,
                ),
                RaisedButton(
                  color: themeData.scaffoldBackgroundColor,
                  onPressed: () {
                    filtering = !filtering;
                    homeTab = HomeTab();
                    SharedPreferences.getInstance().then(
                      (value) {
                        value.setBool('filtering', filtering);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  child: Text(
                    (filtering) ? 'Stop Filtering' : 'Filter Content',
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

class DatePicker extends StatelessWidget {
  final int n;
  DatePicker(this.n);
  @override
  Widget build(BuildContext context) {
    String _text =
        '${DateTime.now().toUtc().subtract(Duration(days: n)) ?? '2020-02-02'}'
            .substring(0, 10);
    return Container(
      height: 50,
      width: 250,
      margin: EdgeInsets.fromLTRB(20, 6, 20, 6),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 9,
        color: themeData.scaffoldBackgroundColor,
        child: Text(
          _text,
          style: themeData.textTheme.headline6,
        ),
        onPressed: (_text == '$currentDay'.substring(0, 10))
            ? null
            : () async {
                lightImpact();
                imageCache.clearLiveImages();
                await SharedPreferences.getInstance().then((value) {
                  value.setInt('$currentDay'.substring(0, 10), docNum);
                  currentDay =
                      DateTime.now().toUtc().subtract(Duration(days: n));
                  docNum = value.getInt('$currentDay'.substring(0, 10)) ?? 0;
                });
                Navigator.of(context).pop();
                medias.forEach((key, value) {
                  if (key.contains('videos')) {
                    value.stop();
                  } else if (key.contains('images')) {
                    value.image.evict();
                  }
                });
                way = 0;
                medias = {};
                homeTab = HomeTab();
                home.setState();
              },
        onLongPress: (_text == '$currentDay'.substring(0, 10))
            ? null
            : () {
                showDialog(
                  context: context,
                  builder: (c) {
                    return Dialog(
                      backgroundColor: themeData.backgroundColor,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14, 20, 14, 16),
                        child: Text(
                          'This app is sorted by days. You can only upload to today, however clicking on this button lets you see posts from $_text.',
                          textAlign: TextAlign.center,
                          style: themeData.textTheme.headline6,
                        ),
                      ),
                    );
                  },
                );
              },
      ),
    );
  }
}
