import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';
import 'package:Archive/MyStuff/MyStyle.dart';

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
    String title =
        time.substring(0, 16).replaceAll('-0', '-').replaceAll(' 0', ' ');
    return ReadDecoration(
      height: height * 0.2,
      margin: EdgeInsets.only(left: width * 0.04, right: width * 0.04, top: 8),
      child: Row(
        children: <Widget>[
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
              (maker==myID || authorizedUser)?Container(
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
                          .collection('${currentDay.toDate()}'.substring(0, 10))
                          .document(docRef)
                          .updateData({time: FieldValue.delete()});
                    }),
              ):Container()
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  title,
                  style: themeData.textTheme.headline6,
                ),
              ),
              Container(
                height: height * 0.162,
                width: width * 0.72,
                color: Color(0x22000000),
                child: ListView(
                  children: <Widget>[
                    StyledText(message),
                  ],
                ),
              )
            ],
          ),
          Center(
            child: Container(
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
          ),
        ],
      ),
    );
  }
}
