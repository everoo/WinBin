import 'dart:async';
import 'package:Archive/Home/HomePage.dart';
import 'package:Archive/MyStuff/MyVideoPlayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';
import 'package:Archive/MyStuff/MyPictureHolder.dart';
import 'package:flutter/physics.dart';
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

class _ReadMemeState extends State<ReadMeme>
    with SingleTickerProviderStateMixin {
  double _mainY = 0;
  AnimationController _anime;
  Animation<double> _ani;
  ScrollController _main = ScrollController();
  double val = way;

  Future _runAnimation(double end) async {
    _ani = _anime.drive(
      Tween(
        begin: val,
        end: end,
      ),
    );

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, 0);
    _anime.animateWith(simulation);
    await Future.delayed(Duration(milliseconds: ((1-val.abs())*70).toInt()+20));
  }

  nextDoc(int way) {
    showingIndicator = false;
    widget.home.goToDoc(docNum += way);
    if (widget.docRef.split('-')[1] == 'videos') {
      widget.media.pause();
    }
  }

  @override
  void initState() {
    super.initState();
    _anime = AnimationController(
      vsync: this,
      value: 1,
      duration: Duration(seconds: 1),
    );
    _anime.addListener(animate);
    _runAnimation(0);
  }

  double offset = 0;
  scroll() {
    // if (_main.position.userScrollDirection == ScrollDirection.forward) {
    //   //setState(() => _mainY);
    // } else {
    //   //setState(() => _mainY = _main.offset);
    // }
//    if (_main.offset + offset < height ) {
    //for when I figure out how to add a way to scroll up and get the thing back in view.
    setState(() => _mainY = _main.offset);
  }

  animate() => setState(() => val = _ani.value);

  int sort(c, n) {
    String _s = '${c.key}'.replaceRange(19, 19, '.');
    String _ss = '${n.key}'.replaceRange(19, 19, '.');
    return DateTime.tryParse(_s).compareTo(DateTime.tryParse(_ss));
  }

  @override
  Widget build(BuildContext context) {
    _main.addListener(scroll);
    List vv = widget.data.entries
        .toList()
        .where((el) => el.key.length == 25)
        .toList();
    vv.sort(sort);
    return Transform.translate(
      offset: Offset(-val * width / 4, val.abs() * (height / -18)),
      child: Transform.rotate(
        angle: val * 1,
        child: Opacity(
          opacity: (0.8 - val.abs()) + 0.2,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: height,
                  width: width * 0.98,
                  margin: EdgeInsets.fromLTRB(width * 0.06, 0, width * 0.06, 0),
                  color: Colors.transparent,
                  child: ListView(
                    controller: _main,
                    children: <Widget>[
                      Container(height: height * 0.53),
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
                          maker: (nn.value.length == 3) ? nn.value[2] : '',
                        ),
                      Container(height: height * 0.13)
                    ],
                  ),
                ),
                onHorizontalDragUpdate: (d) => setState(
                    () => val = (d.globalPosition.dx) * -2 / width + 1),
                onHorizontalDragEnd: (d) {
                  if (d.velocity.pixelsPerSecond.dx < -500 &&
                      docNum < widget.home.datas.length - 1) {
                    way = -1;
                    _runAnimation(1).then((_) => nextDoc(1));
                  } else if (d.velocity.pixelsPerSecond.dx > 500 &&
                      docNum > 0) {
                    way = 1;
                    _runAnimation(-1).then((_) => nextDoc(-1));
                  } else {
                    _runAnimation(0);
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
                                imageSize: Size(widget.data['width'],
                                    widget.data['height']),
                                image: widget.media)
                            : (widget.docRef.split('-')[1] == 'stories')
                                ? Container(
                                    height: height * 0.55,
                                    width: width * 0.98,
                                    child: SingleChildScrollView(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 16, 8, 6),
                                        child: Text(
                                          widget.data['story'] ?? '',
                                          textAlign: TextAlign.center,
                                          style: themeData.textTheme.headline6,
                                        )),
                                  )
                                : MyVideoPlayer(
                                    widget.media, height * 0.55, width * 0.98),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _anime.removeListener(animate);
    _main.removeListener(scroll);
    _anime.dispose();
    _main.dispose();
    super.dispose();
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
          .collection('$currentDay'.substring(0, 10))
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
          String creatorID;
          if (freshSnap.data[comment[0]].length == 3) {
            creatorID = freshSnap.data[comment[0]][2];
          } else {
            creatorID = '';
          }
          await transaction.update(freshSnap.reference, {
            comment[0]: [comment[1], updatedLikers, creatorID]
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
            height: height * 0.03 + 60,
            child: Text(
              'Please wait a few seconds.',
              textAlign: TextAlign.center,
            ))));
    Timer(Duration(seconds: 2), () {
      notShowingSnack = true;
    });
  }
}

addComment(BuildContext context, String docID, {String initialText}) {
  lightImpact();
  if (initialText != null) {
    replyController.text += initialText;
  }
  showDialog<bool>(
    context: context,
    builder: (con) {
      return AlertDialog(
        actionsPadding: EdgeInsets.only(right: width * 0.1),
        backgroundColor: themeData.secondaryHeaderColor,
        title: Text(
          'Do or do not leave a comment, there is no try.',
          style: themeData.textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        content: TextField(
          controller: replyController,
          autofocus: true,
          style: themeData.textTheme.headline6,
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
        actions: <Widget>[
          for (var _n in ['Cancel', 'Clear', 'Send'])
            FlatButton(
                onPressed: () async {
                  lightImpact();
                  if (_n != 'Clear') {
                    Navigator.of(context).pop();
                  }
                  if (_n == 'Send') {
                    if ((replyController.text ?? '').replaceAll(' ', '') !=
                        '') {
                      await Firestore.instance
                          .collection('$currentDay'.substring(0, 10))
                          .document(docID)
                          .updateData({
                        '${DateTime.now().toUtc()}'
                            .replaceAll('.', '')
                            .replaceAll('Z', ''): [
                          replyController.text,
                          {myID: true},
                          myID
                        ]
                      });
                      replyController.clear();
                    }
                  } else if (_n == 'Clear') {
                    replyController.clear();
                  }
                },
                child: Text(_n)),
        ],
      );
    },
  );
}
