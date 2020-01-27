//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Create/createMeme.dart';
import 'package:winbin/Create/createPoll.dart';
import 'package:winbin/Create/createStory.dart';
import 'package:winbin/Create/createVideo.dart';
import 'package:winbin/Globals.dart';
import 'package:winbin/MyStuff/Drawers.dart';

String creationTypeInfo =
    "This is the video creation page. You can edit, merge, and apply filters to videos. Then upload them to the bin. They are a max of seven seconds long.";

class CreateTab extends StatefulWidget {
  _CreateTabState state;
  @override
  _CreateTabState createState() {
    refreshState();
    return state;
  }

  void refreshState() {
    state = _CreateTabState();
  }

  void setState() {
    state.state();
  }
}

class _CreateTabState extends State<CreateTab> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _showcontent() {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeData.backgroundColor,
          title: Text('$creationType Creation Information',
              style: themeData.textTheme.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  creationTypeInfo,
                  style: themeData.textTheme.title,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                lightImpact();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool showingDrawer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Colors.transparent,
      //drawerDragStartBehavior: DragStartBehavior.down,
      drawerEdgeDragWidth: 75,
      drawer: (leftHanded) ? CreateDrawer() : null,
      endDrawer: (!leftHanded) ? CreateDrawer() : null,
      body: Stack(
        children: <Widget>[
          LightCue(leftHanded),
          ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            reverse: true,
            children: <Widget>[
              _CreateType(),
              Container(
                margin: EdgeInsets.fromLTRB(6, 8, 6, 0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: Offset.fromDirection(1, 3),
                          color: Color(0x55000000),
                          blurRadius: 2,
                          spreadRadius: 2)
                    ],
                    color: themeData.backgroundColor,
                    borderRadius: BorderRadius.circular(15)),
                height: 80,
                width: 340,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        creationType,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            color: themeData.textTheme.title.color),
                      ),
                    ),
                    RaisedButton(
                      elevation: 0,
                      color: Colors.transparent,
                      disabledColor: Colors.transparent,
                      onPressed: () {
                        _showcontent();
                        lightImpact();
                      },
                      child: Icon(
                        Icons.info_outline,
                        color: themeData.textTheme.title.color,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: (leftHanded) ? null : EdgeInsets.only(left: 325),
            height: 650,
            width: 50,
            child: GestureDetector(
              onTap: () {
                lightImpact();
                (leftHanded)
                    ? _drawerKey.currentState.openDrawer()
                    : _drawerKey.currentState.openEndDrawer();
              },
            ),
          )
        ],
      ),
    );
  }

  void state() {
    setState(() {});
  }
}

class _CreateType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (creationType == "Video") {
      creationTypeInfo =
          "This is the video creation page. You can edit, merge, and apply filters to videos. Then upload them to the bin. They are a max of seven seconds long.";
      return CreateVideo();
    } else if (creationType == "Poll") {
      creationTypeInfo =
          "This is when you have a question that you want answered. Just put in your question and up to 16 answers(if this ends up being too small I'll change the amount). Then send it off to recieve what the world thinks of it.";
      return CreatePoll();
    } else if (creationType == "Image") {
      creationTypeInfo = "The silent part of a video.";
      return CreateMeme();
    } else if (creationType == "Story") {
      creationTypeInfo =
          "Did something funny happen? Did you see something weird? Wanna let off some steam? Write a story about it. \nYou can stylize your text in the following ways: \nSize: any +num(defaults to 14) \nColor: red, blue, green, yellow, purple, teal \nHighlight: same colors but put an h in front(hred) \nWrite italic and/or bold to do those. Seperate each stylization with a '|'.";
      return CreateStory();
    } else {
      creationTypeInfo =
          "You really, I mean really, should not have gotten here. How did you do it?";
      return Container(
        child: Center(
          child: Text("You shouldn't be here"),
        ),
      );
    }
  }
}
