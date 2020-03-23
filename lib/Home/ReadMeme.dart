import 'dart:async';
import 'package:Archive/Home/HomePage.dart';
import 'package:Archive/MyStuff/MyStyle.dart';
import 'package:Archive/MyStuff/MyVideoPlayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';
import 'package:Archive/MyStuff/MyPictureHolder.dart';
import 'package:flutter/rendering.dart';

import 'CommentCard.dart';
import 'ReadPoll.dart';

class ReadMeme extends StatefulWidget {
  final String docRef;
  final Map<String, dynamic> data;
  final media;
  final HomeTabState home;

  ReadMeme(this.docRef, this.data, this.media, this.home);

  @override
  _ReadMemeState createState() => _ReadMemeState();
}

class _ReadMemeState extends State<ReadMeme> {
  double _mainY = 0;

  @override
  Widget build(BuildContext context) {
    ScrollController _main = ScrollController();
    _main.addListener(() {
      // if (_main.position.userScrollDirection == ScrollDirection.forward) {
      //   setState(() => _mainY = 0);
      // } else {
      // }
      // use this if I want the meme to pop back up when they start to slide down again
      setState(() => _mainY = _main.offset);
      bgController.jumpTo(_main.offset * 3 / 4 + height);
    });
    List vv = widget.data.entries
        .toList()
        .where((el) => el.key.length == 25)
        .toList();
    vv.sort((c, n) {
      return DateTime(
        int.tryParse(c.key.substring(0, 4)),
        int.tryParse(c.key.substring(5, 7)),
        int.tryParse(c.key.substring(8, 10)),
        int.tryParse(c.key.substring(11, 13)),
        int.tryParse(c.key.substring(14, 16)),
        int.tryParse(c.key.substring(17, 19)),
        int.tryParse(c.key.substring(19, 22)),
      ).compareTo(DateTime(
        int.tryParse(n.key.substring(0, 4)),
        int.tryParse(n.key.substring(5, 7)),
        int.tryParse(n.key.substring(8, 10)),
        int.tryParse(n.key.substring(11, 13)),
        int.tryParse(n.key.substring(14, 16)),
        int.tryParse(n.key.substring(17, 19)),
        int.tryParse(n.key.substring(19, 22)),
      ));
    });
    return Container(
      height: height,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              height: height,
              color: Colors.transparent,
              child: ListView(
                controller: _main,
                children: <Widget>[
                  Container(height: height * 0.56),
                  for (var nn in vv)
                    CommentCard(
                      docRef: widget.docRef,
                      message: nn.value[0] ?? '',
                      likes: (nn.value[1] ?? {})
                          .values
                          .where((e) => (e == true) ? true : false)
                          .length,
                      dislikes: (nn.value[1] ?? {})
                          .values
                          .where((e) => (e == false) ? true : false)
                          .length,
                      time: nn.key ?? '',
                      maker: (vv.length==3)?nn.value[2]:'',
                    ),
                  Container(height: height * 0.2)
                ],
              ),
            ),
            onHorizontalDragEnd: (d) {
              if (d.velocity.pixelsPerSecond.dx < -500 &&
                  docNum < widget.home.datas.length - 1) {
                widget.home.goToDoc(docNum += 1);
                if (widget.docRef.split('-')[1] == 'videos') {
                  widget.media.pause();
                }
              }
              if (d.velocity.pixelsPerSecond.dx > 500 && docNum > 0) {
                widget.home.goToDoc(docNum -= 1);
                if (widget.docRef.split('-')[1] == 'videos') {
                  widget.media.pause();
                }
              }
            },
          ),
          Transform.translate(
            offset: Offset(0, _mainY / -2),
            child: (widget.docRef.split('-')[1] == 'polls')
                ? ReadPoll(widget.docRef, widget.data)
                : ReadDecoration(
                    height: height * 0.55,
                    child: (widget.docRef.split('-')[1] == 'images')
                        ? MyPictureHolder(
                            width: width * 0.98,
                            height: height * 0.55,
                            imageSize: Size(
                                widget.data['width'], widget.data['height']),
                            image: widget.media)
                        : (widget.docRef.split('-')[1] == 'stories')
                            ? SingleChildScrollView(
                                child: StyledText(widget.data['story'] ?? ''))
                            : MyVideoPlayer(
                                widget.media, height * 0.55, width * 0.98),
                  ),
          )
        ],
      ),
    );
  }
}

bool notShowingSnack = true;
bool hasNotLikedRecently = true;
void like(BuildContext context, bool like, String docRef,
    {List comment}) async {
  if (hasNotLikedRecently) {
    hasNotLikedRecently = false;
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(Firestore.instance
          .collection('${currentDay.toDate()}'.substring(0, 10))
          .document(docRef));
      if (freshSnap.exists) {
        Map updatedLikers;
        if (comment == null) {
          updatedLikers = freshSnap.data['likes'] ?? {};
        } else {
          updatedLikers = freshSnap.data[comment[0]][1] ?? {};
        }
        bool oldWay = updatedLikers[myID] ?? null;
        if (oldWay == null) {
          updatedLikers.addAll({myID: like});
        } else if (oldWay == like) {
          updatedLikers.remove(myID);
        } else {
          updatedLikers.update(myID, (value) => like);
        }
        if (comment != null && (freshSnap.data[comment[0]]) != updatedLikers) {
          await transaction.update(freshSnap.reference, {
            comment[0]: [comment[1], updatedLikers]
          });
        }
        if (comment == null) {
          await transaction
              .update(freshSnap.reference, {'likes': updatedLikers});
        }
      }
      Timer(Duration(seconds: 1), () => hasNotLikedRecently = true);
    });
  } else if (notShowingSnack) {
    notShowingSnack = false;
    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Container(
            height: 20,
            child: Center(child: Text('Please wait a few seconds.')))));
    Timer(Duration(seconds: 2), () {
      notShowingSnack = true;
    });
  }
}
