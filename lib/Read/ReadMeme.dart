import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Comments/CommentBar.dart';
import 'package:winbin/main.dart';

class ReadMeme extends StatefulWidget {
  final String docRef;
  final Uint8List imgFile;
  ReadMeme(this.docRef, this.imgFile);
  @override
  _ReadMemeState createState() => _ReadMemeState(docRef, imgFile);
}

class _ReadMemeState extends State<ReadMeme>
    with AutomaticKeepAliveClientMixin {
  final String docRef;
  final Uint8List imgFile;

  _ReadMemeState(this.docRef, this.imgFile);
  Stream<DocumentSnapshot> _stream;

  @override
  void initState() {
    _stream =
        Firestore.instance.collection('images').document(docRef).snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Text('this didnt load properly\n${snapshot.error}'),
            ),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (imgFile == null) {
              return Container();
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset.fromDirection(1, 3),
                            color: Color(0x55000000),
                            blurRadius: 2,
                            spreadRadius: 2)
                      ],
                      color: themeData.backgroundColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Image.memory(
                            imgFile,
                            fit: BoxFit.cover,
                          ),
                          height: 400,
                          width: 315,
                          margin: EdgeInsets.only(top: 5),
                        ),
                      ),
                      CommentBar(
                          '${snapshot.data['likes']}',
                          '${snapshot.data['dislikes']}',
                          '${snapshot.data['comments']}',
                          context,
                          docRef,
                          'images')
                    ],
                  ),
                ),
              );
            }
            break;
          default:
            return Container();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
