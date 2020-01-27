import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winbin/Globals.dart';
import 'package:winbin/MyStuff/Drawers.dart';
import 'package:winbin/Read/ReadMeme.dart';
import 'package:winbin/Read/ReadPoll.dart';
import 'package:winbin/Read/ReadStory.dart';
import 'package:winbin/Read/ReadVideo.dart';
import 'package:winbin/main.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  List<String> flaggedPosts;
  List<String> flaggedUsers;
  ScrollController _scrollController =
      ScrollController(keepScrollOffset: false);

  @override
  bool wantKeepAlive = true;

  bool notInitialized = true;
  Future<void> initAccount() async {
    if (notInitialized) {
      notInitialized = false;
      _scrollController.addListener(() {
        bgController.jumpTo(_scrollController.offset * .5 + 500);
      });
      SharedPreferences sharedP = await SharedPreferences.getInstance();
      myID = sharedP.getString('uid') ?? null;
      print(myID);
      flaggedUsers = sharedP.getStringList('flaggedUsers') ?? [];
      flaggedPosts = sharedP.getStringList('flaggedPosts') ?? [];
      currentBoard = sharedP.getString('currentBoard') ?? 'A';
      if (myID == null) {
        DocumentReference fs =
            Firestore.instance.collection('uids').document('all');
        String returnable = '';
        int rando = Random().nextInt(62);
        var all = await fs.get();
        while (all.data.keys.contains(returnable) || returnable == '') {
          returnable = returnable +
              'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
                  .substring(rando, rando + 1);
        }
        myID = returnable;
        sharedP.setString('uid', myID);
        await fs.updateData({returnable: true});
      }
    }
  }

  bool gottenStreams = false;
  void getStreams() {
    ['A', 'B', 'C', 'D'].forEach((s) {
      streams[s] = Firestore.instance
          .collection(s)
          .document('${Timestamp.now().toDate()}'.substring(0, 10))
          .snapshots();
      streams[s].first.then((d) {
        if (!d.exists) {
          Firestore.instance
              .collection(s)
              .document('${Timestamp.now().toDate()}'.substring(0, 10))
              .setData({'null': 'null'});
        }
        if (s == currentBoard) {
          d.data.remove('null');
          d.data.forEach((k, v) {
            print(v);
            currentStream.addEntries({
              MapEntry(
                  v,
                  Firestore.instance
                      .collection(v.split('-')[1])
                      .document(v)
                      .snapshots())
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    initAccount();
    getStreams();
    super.build(context);
    return Scaffold(
      key: homeDrawerKey,
      drawerEdgeDragWidth: 50,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          LightCue(!leftHanded),
          StreamBuilder<DocumentSnapshot>(
              stream: streams[currentBoard],
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorMessage(snapshot.error);
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    snapshot.data.data.remove('null');
                    List newData = [];
                    for (int v in List<int>.generate(
                        snapshot.data.data.length, (int index) => index)) {
                      newData.add(snapshot.data.data['$v']);
                    }
                    List<Widget> _widgets = [
                      for (var v in currentStream.keys)
                        (flaggedUsers.contains(v.split('-')[2]))
                            ? Container()
                            : (flaggedPosts.contains(v))
                                ? Container()
                                : (v.split('-')[1] == 'images')
                                    ? ReadMeme(v, currentStream[v])
                                    : (v.split('-')[1] == 'polls')
                                        ? ReadPoll(v, currentStream[v])
                                        : (v.split('-')[1] == 'stories')
                                            ? ReadStory(v, currentStream[v])
                                            : (v.split('-')[1] == 'videos')
                                                ? ReadVideo(v, currentStream[v])
                                                : Container(),
                      Container(
                        height: 8,
                      )
                    ];
                    return ListView(
                      controller: _scrollController,
                      children: _widgets,
                    );

                    break;
                  default:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }
              }),
          Container(
            margin: (leftHanded) ? EdgeInsets.only(left: 325) : null,
            height: 650,
            width: 50,
            child: GestureDetector(
              onTap: () {
                lightImpact();
                (leftHanded)
                    ? homeDrawerKey.currentState.openEndDrawer()
                    : homeDrawerKey.currentState.openDrawer();
              },
            ),
          )
        ],
      ),
      endDrawer: (leftHanded) ? HomeDrawer() : null,
      drawer: (leftHanded) ? null : HomeDrawer(),
    );
  }
}
