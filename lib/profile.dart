import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winbin/Read/ReadMeme.dart';
import 'package:winbin/Read/ReadPoll.dart';
import 'package:winbin/Read/ReadStory.dart';
import 'package:winbin/main.dart';
import 'package:winbin/signIn.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with AutomaticKeepAliveClientMixin {
  SliverGridDelegate gridDelegate =
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3);
  Stream<DocumentSnapshot> _stream;
  String prevUsername = '';

  @override
  void initState() {
    super.initState();
    _stream = Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .snapshots();
    //  scrollers[2].addListener(listener);
  }

  void listener() {
    //bgController.jumpTo((scrollers[2].offset / 4) + 150);
  }

  TextEditingController controller = TextEditingController();
  FocusNode foucs = FocusNode();
  bool _editing = false;
  int _value = 0;
  bool showingExample = false;
  String example = '';

  @override
  Widget build(BuildContext context) {

    super.build(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomInset: true,
          resizeToAvoidBottomPadding: true,
          backgroundColor: Colors.transparent,
          endDrawer: Drawer(
            child: Container(
              color: themeData.backgroundColor,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Container(
                      width: 300,
                      height: 120,
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 15, 15, 0),
                              child: Text(
                                'Dark Mode',
                                style: TextStyle(
                                    color: themeData.textTheme.title.color),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomSwitch(),
                          ),
                          //(currentMode!=darkMode)?Center(child: Text('resets when you restart the app', style: themeData.textTheme.title,),):Container()
                        ],
                      ),
                    ),
                  ),
                  // this resets it better but it looks wierd
                  // Container(
                  //   width: 300,
                  //   height: 50,
                  //   child: Slider(
                  //     onChanged: (v) {
                  //       setState(() {
                  //         _value = v.round();
                  //         if (_value==0) {
                  //           themeMode = ThemeMode.dark;
                  //           themeData = darkThemeData;
                  //           darkMode = true;
                  //         } else if (_value==1) {
                  //           themeMode = ThemeMode.light;
                  //           themeData = lightThemeData;
                  //           darkMode = false;
                  //         }
                  //       });
                  //       this.context.owner.finalizeTree();
                  //     },
                  //     value: _value.toDouble(),
                  //     max: 1,
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: StreamBuilder<DocumentSnapshot>(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text("Loading...");
                  default:
                    while (snapshot.data == null) {}
                    currentUsersName = snapshot.data['username'];
                    controller.text = currentUsersName;
                    prevUsername = currentUsersName;
                    return ListView(
                      physics: ClampingScrollPhysics(),
                      reverse: true,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          height: 515,
                          width: 300,
                          child: Stack(
                            children: <Widget>[
                              GridView(
                                padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
                                //controller: scrollers[2],
                                gridDelegate: gridDelegate,
                                children: <Widget>[
                                  for (String snap in snapshot.data['posts'])
                                    Padding(
                                      child: RaisedButton(
                                        elevation: 8,
                                        color: themeData.backgroundColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        onPressed: () {
                                          example = snap;
                                          setState(() {
                                            showingExample = !showingExample;
                                          });
                                        },
                                        child: Icon(
                                          (snap.split('-').first == 'images')
                                              ? Icons.image
                                              : (snap.split('-').first ==
                                                      'polls')
                                                  ? Icons.poll
                                                  : (snap
                                                              .split('-')
                                                              .first ==
                                                          'videos')
                                                      ? Icons.play_circle_filled
                                                      : (snap
                                                                  .split('-')
                                                                  .first ==
                                                              'songs')
                                                          ? Icons.audiotrack
                                                          : (snap
                                                                      .split(
                                                                          '-')
                                                                      .first ==
                                                                  'stories')
                                                              ? Icons
                                                                  .import_contacts
                                                              : Icons
                                                                  .sentiment_neutral,
                                          size: 38,
                                          color: themeData.colorScheme.primary,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(4),
                                    )
                                ],
                              ),
                              (showingExample)
                                  ? ListView(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              50, 10, 50, 0),
                                          child: RaisedButton(
                                            color:
                                                themeData.secondaryHeaderColor,
                                            child: Text(
                                              'Back',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: themeData
                                                      .textTheme.title.color),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                showingExample =
                                                    !showingExample;
                                              });
                                            },
                                            padding: EdgeInsets.fromLTRB(
                                                20, 20, 20, 20),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                          ),
                                        ),
                                        (example.split('-').first == 'polls')
                                            ? ReadPoll(example)
                                            : (example.split('-').first == 'stories')
                                                ? ReadStory(example)
                                                : (example.split('-').first == 'images')
                                                    ? ReadMeme(example, Uint8List(0))
                                                    : (example.split('-').first == 'polls')
                                                        ? ReadPoll(example)
                                                        : Container(),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          width: 360,
                          height: 75,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset.fromDirection(1, 3),
                                    color: Color(0x55000000),
                                    blurRadius: 2,
                                    spreadRadius: 2)
                              ],
                              color: themeData.backgroundColor,
                              borderRadius: BorderRadius.circular(18)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  width: (_editing) ? 220 : 250,
                                  child: TextField(
                                    onEditingComplete: () {
                                      if (controller.text != prevUsername) {
                                        if (controller.text.length <= 30 &&
                                            controller.text.length > 0) {
                                          Firestore.instance
                                              .collection('users')
                                              .document(currentUser.uid)
                                              .updateData({
                                            'username': controller.text
                                          });
                                          prevUsername = controller.text;
                                        } else {
                                          setState(() {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Your username must be shorter than 30 characters, and not empty.'),
                                            ));
                                          });
                                        }
                                      }
                                      foucs.unfocus();
                                      _editing = false;
                                    },
                                    focusNode: foucs,
                                    controller: controller,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 24,
                                        color: (darkMode)
                                            ? Colors.grey[400]
                                            : Colors.black),
                                    decoration: InputDecoration(
                                      labelStyle: themeData.textTheme.title,
                                      errorStyle: themeData.textTheme.title,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 750),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 30,
                                        child: (_editing)
                                            ? IconButton(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                icon: Icon(
                                                  Icons.clear,
                                                  color: themeData.splashColor,
                                                ),
                                                onPressed: () {
                                                  _editing = false;
                                                  foucs.unfocus();
                                                },
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: themeData.splashColor,
                                                ),
                                                onPressed: () {
                                                  foucs.requestFocus();
                                                  _editing = true;
                                                },
                                              )),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      width: 24,
                                      child: IconButton(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        icon: Icon(
                                          Icons.accessible_forward,
                                          color: themeData.splashColor,
                                        ),
                                        onPressed: signOut,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void signOut() {
    currentUser = null;
    currentUsersName = null;
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage(false)));
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomSwitch extends StatefulWidget {
  bool state = darkMode;
  double left = 0;
  double right = 0;
  @override
  State<StatefulWidget> createState() {
    return _CustomSwitch();
  }
}

class _CustomSwitch extends State<CustomSwitch> {
  double left = (themeMode == ThemeMode.dark) ? 0 : 173;
  double right = (themeMode == ThemeMode.dark) ? 173 : 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 70,
        child: RaisedButton(
          color: themeData.scaffoldBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  color: themeData.secondaryHeaderColor,
                  width: 200,
                  height: 10,
                ),
              ),
              AnimatedContainer(
                //color: themeData.secondaryHeaderColor,
                margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                padding: EdgeInsets.fromLTRB(left, 0, right, 0),
                duration: Duration(milliseconds: 750),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset.fromDirection(1, 3),
                            color: Color(0x55000000),
                            blurRadius: 2,
                            spreadRadius: 2)
                      ],
                      color: themeData.colorScheme.primary,
                      borderRadius: BorderRadius.circular(30)),
                  height: 60,
                  width: 200,
                ),
              )
            ],
          ),
          onPressed: () {
            setState(() {
              if (themeMode != ThemeMode.dark) {
                left = 0;
                right = 173;
                themeMode = ThemeMode.dark;
                themeData = darkThemeData;
                darkMode = true;
              } else {
                left = 173;
                right = 0;
                themeMode = ThemeMode.light;
                themeData = lightThemeData;
                darkMode = false;
              }
            });
            this.context.owner.finalizeTree();
            SharedPreferences.getInstance().then((d) {
              d.setBool('darkMode', darkMode);
            });
          },
        ),
      ),
    );
  }
}
