import 'package:Archive/Create/createMedia.dart';
import 'package:flutter/material.dart';
import 'package:Archive/Create/createPoll.dart';
import 'package:Archive/Create/createStory.dart';
import 'package:Archive/Globals.dart';
import 'package:Archive/MyStuff/Drawers.dart';

class CreateTab extends StatefulWidget {
  @override
  _CreateTabState createState() => _CreateTabState();
}

class _CreateTabState extends State<CreateTab>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Colors.transparent,
      drawerEdgeDragWidth: width / 5,
      drawer: (leftHanded) ? CreateDrawer() : null,
      endDrawer: (leftHanded) ? null : CreateDrawer(),
      body: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        reverse: true,
        children: <Widget>[
          (creationType == "Video")
              ? CreateMedia(false)
              : (creationType == "Poll")
                  ? CreatePoll()
                  : (creationType == "Image")
                      ? CreateMedia(true)
                      : (creationType == "Story")
                          ? CreateStory()
                          : Container(),
          Container(
            margin: EdgeInsets.fromLTRB(
                width * 0.01, height * 0.01, width * 0.01, 0),
            height: height * 0.11,
            child: Stack(
              children: <Widget>[
                RaisedButton(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: themeData.backgroundColor,
                  onPressed: () {
                    if (leftHanded) {
                      _drawerKey.currentState.openDrawer();
                    } else {
                      _drawerKey.currentState.openEndDrawer();
                    }
                  },
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return Dialog(
                            backgroundColor: themeData.backgroundColor,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(14, 20, 14, 16),
                              child: Text(
                                (creationType == 'Image' ||
                                        creationType == "Video")
                                    ? 'You can upload a max of 25 MB.\nIt takes a second for things to upload so once you feel a second click it has succesfully uploaded.'
                                    : (creationType == 'Poll')
                                        ? 'You can have up to 15 answers to your one question. Each with a max of 128 characters.'
                                        : 'You can have a max of 10000 characters.\nThe eye button allows you to switch between seeing the final and editing.\nTo stylize something put a hyphen after it then the stylization, you can have multiple. Possible stylizations are green, red, blue, teal, yellow, purple, bold, italic, and size(0-400).\n To split up stylizations use a / to start and end it.\nExample: /text-red-hyellow-88-bold-italic/',
                                textAlign: TextAlign.center,
                                style: themeData.textTheme.headline6,
                              ),
                            ),
                          );
                        });
                  },
                  child: Center(
                    child: Text(
                      creationType ?? 'Image',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          color: themeData.textTheme.headline6.color),
                    ),
                  ),
                ),
                
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
