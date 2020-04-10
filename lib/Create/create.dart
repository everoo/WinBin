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
  @override
  Widget build(BuildContext context) {
    List<Widget> _wids = [
      IconButton(
          icon: Icon((leftHanded) ? Icons.arrow_forward : Icons.arrow_back),
          onPressed: () => (tabController.index == 1)
              ? tabController.animateTo(0)
              : tabController.animateTo(1),
          color: themeData.textTheme.headline6.color),
      Text(
        creationType ?? 'Image',
        style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: themeData.textTheme.headline6.color),
      ),
      Icon(
        Icons.menu,
        color: themeData.textTheme.headline6.color,
        size: 30,
      )
    ];
    if (leftHanded) _wids = _wids.reversed.toList();
    super.build(context);
    return Scaffold(
      key: createDrawerKey,
      backgroundColor: Colors.transparent,
      drawerEdgeDragWidth: width / 5,
      drawer: (leftHanded) ? CreateDrawer() : null,
      endDrawer: (leftHanded) ? null : CreateDrawer(),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        reverse: true,
        children: <Widget>[
          (creationType == "Video")
              ? CreateMedia(false)
              : (creationType == "Poll")
                  ? CreatePoll()
                  : (creationType == "Image")
                      ? CreateMedia(true)
                      : (creationType == "Story") ? CreateStory() : Container(),
          Container(
            margin: EdgeInsets.fromLTRB(
                width * 0.01, height * 0.01, width * 0.01, 0),
            height: height * 0.11,
            child: RaisedButton(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: themeData.backgroundColor,
              onPressed: () {
                if (leftHanded) {
                  createDrawerKey.currentState.openDrawer();
                } else {
                  createDrawerKey.currentState.openEndDrawer();
                }
              },
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (c) {
                      return Dialog(
                        insetPadding: EdgeInsets.fromLTRB(14, 20, 14, 16),
                        backgroundColor: themeData.backgroundColor,
                        child: Text(
                          (creationType == 'Image' || creationType == "Video")
                              ? 'You can upload a max of 25 MB.\nIt takes a second for things to upload so once you feel a second click it has succesfully uploaded.'
                              : (creationType == 'Poll')
                                  ? 'You can have up to 15 answers to your one question. Each with a max of 128 characters.'
                                  : 'You can have a max of 100000 characters.',
                          textAlign: TextAlign.center,
                          style: themeData.textTheme.headline6,
                        ),
                      );
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _wids,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
