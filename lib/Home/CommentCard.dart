import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';

import 'ReadMeme.dart';

class CommentCard extends StatelessWidget {
  final String time;
  final String message;
  final String docRef;
  final String maker;
  final int likes;
  final int dislikes;

  CommentCard(
      {this.time,
      this.message,
      this.likes,
      this.dislikes,
      this.docRef,
      this.maker});

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgets = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: width * 0.1,
            height: height * 0.09,
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Column(
                children: <Widget>[
                  Text('$dislikes', style: themeData.textTheme.headline6),
                  Icon(Icons.thumb_down,
                      color: themeData.textTheme.headline6.color)
                ],
              ),
              onPressed: () {
                lightImpact();
                like(context, false, docRef, comment: [time, message]);
              },
            ),
          ),
          (maker == myID || authorizedUser)
              ? Container(
                  width: width * 0.1,
                  height: height * 0.09,
                  child: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: themeData.textTheme.headline6.color,
                      ),
                      onPressed: () {
                        lightImpact();
                        Firestore.instance
                            .collection('$currentDay'.substring(0, 10))
                            .document(docRef)
                            .updateData({time: FieldValue.delete()});
                      }),
                )
              : Container()
        ],
      ),
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              time.substring(0, 19).replaceAll('-0', '-').replaceAll(' 0', ' '),
              style: themeData.textTheme.headline6,
            ),
          ),
          Container(
              height: height * 0.16,
              width: width * 0.675,
              color: themeData.accentColor,
              child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: themeData.textTheme.headline6,
                  )))
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: width * 0.1,
            height: height * 0.09,
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Column(
                children: <Widget>[
                  Text('$likes', style: themeData.textTheme.headline6),
                  Icon(Icons.thumb_up,
                      color: themeData.textTheme.headline6.color)
                ],
              ),
              onPressed: () {
                lightImpact();
                like(context, true, docRef, comment: [time, message]);
              },
            ),
          ),
          (maker != myID)
              ? Container(
                  width: width * 0.1,
                  height: height * 0.09,
                  child: IconButton(
                      icon: Icon(
                        Icons.reply,
                        color: themeData.textTheme.headline6.color,
                      ),
                      onPressed: () {
                        lightImpact();
                        addComment(context, docRef, initialText: '@$time\n ');
                      }),
                )
              : Container()
        ],
      ),
    ];
    if (leftHanded) _widgets = _widgets.reversed.toList();
    return ReadDecoration(
      height: height * 0.2,
      margin: EdgeInsets.only(top: 6),
      child: Row(
        children: _widgets,
      ),
    );
  }
}
