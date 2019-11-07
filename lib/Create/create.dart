import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Create/createMeme.dart';
import 'package:winbin/Create/createMusic.dart';
import 'package:winbin/Create/createPoll.dart';
import 'package:winbin/Create/createStory.dart';
import 'package:winbin/Create/createVideo.dart';
import 'package:winbin/main.dart';

String _creationType = "Poll";
String _creationTypeInfo =
    "This is the video creation page. You can edit, merge, and apply filters to videos. Then upload them to the bin. They are a max of seven seconds long.";

class CreateTab extends StatefulWidget {
  @override
  _CreateTabState createState() => _CreateTabState();
}

class _CreateTabState extends State<CreateTab> {
  void _showcontent() {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeData.backgroundColor,
          title: Text('$_creationType Creation Information',
              style: themeData.textTheme.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  _creationTypeInfo,
                  style: themeData.textTheme.title,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.transparent,
      drawerDragStartBehavior: DragStartBehavior.down,
      drawer: Drawer(
        child: Container(
          color: themeData.colorScheme.background,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(12, 10, 5, 10),
                    child: RaisedButton(
                      elevation: 4,
                      color: themeData.colorScheme.secondaryVariant,
                      padding: EdgeInsets.fromLTRB(42.5, 76, 42.5, 76),
                      child: Icon(Icons.audiotrack, size: 50.0),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _creationType = "Audio";
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 10, 12, 10),
                    child: RaisedButton(
                      elevation: 4,
                      color: themeData.colorScheme.primary,
                      padding: EdgeInsets.fromLTRB(42.5, 76, 42.5, 76),
                      child: Icon(Icons.image, size: 50.0),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _creationType = "Image";
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: RaisedButton(
                  elevation: 4,
                  color: themeData.colorScheme.primaryVariant,
                  padding: EdgeInsets.fromLTRB(115, 55, 120, 55),
                  child: Icon(Icons.play_circle_filled, size: 50.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _creationType = "Video";
                    });
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(12, 10, 5, 10),
                    child: RaisedButton(
                      elevation: 4,
                      color: themeData.colorScheme.secondary,
                      padding: EdgeInsets.fromLTRB(42.5, 76, 42.5, 76),
                      child: Icon(Icons.import_contacts, size: 50.0),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _creationType = "Story";
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 10, 12, 10),
                    child: RaisedButton(
                      elevation: 4,
                      color: themeData.colorScheme.surface,
                      padding: EdgeInsets.fromLTRB(42.5, 76, 42.5, 76),
                      child: Icon(Icons.poll, size: 50.0),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _creationType = "Poll";
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        reverse: true,
        children: <Widget>[
          _CreateType(),
          Container(
            margin: EdgeInsets.fromLTRB(5, 22, 5, 0),
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
            height: 77,
            width: 340,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    _creationType,
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
                  onPressed: _showcontent,
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
    );
  }
}

class _CreateType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (_creationType == "Video") {
      _creationTypeInfo =
          "This is the video creation page. You can edit, merge, and apply filters to videos. Then upload them to the bin. They are a max of seven seconds long.";
      return CreateVideo();
    } else if (_creationType == "Poll") {
      _creationTypeInfo =
          "This is when you have a question that you want answered. Just put in your question and up to 16 answers(if this ends up being too small I'll change the amount). Then send it off to recieve what the world thinks of it.";
      return CreatePoll();
    } else if (_creationType == "Audio") {
      _creationTypeInfo = "The loud part of a video.";
      return CreateMusic();
    } else if (_creationType == "Image") {
      _creationTypeInfo = "The silent part of a video.";
      return CreateMeme();
    } else if (_creationType == "Story") {
      _creationTypeInfo =
          "Did something funny happen? Did you see something weird? Wanna let off some steam? Write a story about it. \nYou can stylize your text in the following ways: \nSize: any +num(defaults to 14) \nColor: red, blue, green, yellow, purple, teal \nHighlight: same colors but put an h in front(hred) \nWrite italic and/or bold to do those. Seperate each stylization with a '|'.";
      return CreateStory();
    } else {
      _creationTypeInfo =
          "Like you really should not have gotten here. How did you do it?";
      return Container(
        child: Center(
          child: Text("You shouldn't be here"),
        ),
      );
    }
  }
}
