import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Comments/CommentBar.dart';
import 'package:winbin/Globals.dart';
import 'package:winbin/MyStuff/MyStyle.dart';

class ReadStory extends StatefulWidget {
  final String docRef;

  final Stream<DocumentSnapshot> stream;
  ReadStory(this.docRef, this.stream);
  @override
  _ReadStoryState createState() => _ReadStoryState(docRef, stream);
}

class _ReadStoryState extends State<ReadStory> {
  final String docRef;
  double height = 0;
  StyledText sText;
  String copyable = '';
  _ReadStoryState(this.docRef, this._stream);
  final Stream<DocumentSnapshot> _stream;

  @override
  void initState() {
    super.initState();
  }

  int cou = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorMessage(snapshot.error);
        }
        if (snapshot.data != null) {
          if (snapshot.data.data != null) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                if (height == 0) {
                  height = min(
                      (snapshot.data['story'].toString().length.toDouble() /
                                  48) *
                              15 +
                          50,
                      277);
                }
                if (copyable == '' && snapshot.data['story'] != null) {
                  snapshot.data['story'].split('/').forEach((d) {
                    copyable += d.split('|').first;
                  });
                }
                return ReadDecoration(
                  height: (height == 0) ? 123 : height + 73,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        height: height,
                        child: ListView(
                          children: <Widget>[
                            sText =
                                StyledText(ogString: snapshot.data['story']),
                          ],
                        ),
                      ),
                      CommentBar(
                          '${snapshot.data['likes']}',
                          '${snapshot.data['dislikes']}',
                          '${snapshot.data['comments']}',
                          context,
                          docRef,
                          'stories',
                          copyable)
                    ],
                  ),
                );
              default:
                return Container(height: 123);
            }
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }
}
