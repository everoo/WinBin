import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Globals.dart';
import 'package:winbin/MyStuff/MyStyle.dart';

class CommentCard extends StatelessWidget {
  final String time;
  final String message;
  final int likes;
  final int dislikes;
  final int n;
  final String documentRef;
  final String name;

  CommentCard(
      {Key key,
      this.name,
      this.time,
      this.message,
      this.likes,
      this.dislikes,
      this.documentRef,
      this.n})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ReadDecoration(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                (time.substring(5, 16).startsWith('0'))
                    ? time.substring(5, 16).substring(1)
                    : time.substring(5, 16),
                style: themeData.textTheme.title,
              ),
            ),
            Container(
              height: min(message.length.toDouble() / 48 * 15 + 40, 277),
              width: 300,
              child: ListView(
                children: <Widget>[StyledText(ogString: message)],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 40,
                  child: (name != null)
                      ? FlatButton(
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.reply,
                                color: themeData.textTheme.title.color,
                              ),
                            ],
                          ),
                          onPressed: () {
                            lightImpact();
                          },
                        )
                      : null,
                ),
                Text(
                  '${likes + currentLikes}',
                  style: themeData.textTheme.title,
                ),
                Container(
                  width: 60,
                  child: FlatButton(
                    child: Icon(
                      Icons.thumb_up,
                      color: themeData.textTheme.title.color,
                    ),
                    onPressed: () {
                      lightImpact();
                      like(1);
                    },
                  ),
                ),
                Container(
                  width: 60,
                  child: FlatButton(
                    child: Icon(
                      Icons.thumb_down,
                      color: themeData.textTheme.title.color,
                    ),
                    onPressed: () {
                      lightImpact();
                      like(-1);
                    },
                  ),
                ),
                Text(
                  '${dislikes + currentDislikes}',
                  style: themeData.textTheme.title,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  int currentLikes = 0;
  int currentDislikes = 0;
  bool hasSentLikes = true;

  void like(int way) {
    if (way == 1) {
      currentLikes += way;
    } else {
      currentDislikes -= way;
    }
    print([currentLikes, currentDislikes]);
    print(hasSentLikes);
    if (hasSentLikes) {
      hasSentLikes = false;
      Timer(Duration(seconds: 5), () {
        sendLikes();
      });
    }
  }

  void sendLikes() {
    Firestore.instance.runTransaction((transaction) async {
      print('recieving');
      DocumentSnapshot freshSnap = await transaction.get(Firestore.instance
          .collection(documentRef.split('-')[1])
          .document(documentRef)
          .collection('comments')
          .document('comment$n'));
      print(freshSnap.data);
      int thing1 = freshSnap.data['likes'] + currentLikes;
      int thing2 = freshSnap.data['dislikes'] + currentDislikes;
      print([thing1, thing2]);
      await transaction
          .update(freshSnap.reference, {'likes': thing1, 'dislikes': thing2});
      currentLikes = 0;
      currentDislikes = 0;
      hasSentLikes = true;
      print('sent');
    });
  }
}
