import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart'; ////

import 'package:winbin/Comments/CommentBar.dart';
import 'package:winbin/Globals.dart';
import 'package:winbin/MyStuff/MyVideoPlayer.dart';

class ReadVideo extends StatefulWidget {
  final String docRef;

  final Stream<DocumentSnapshot> stream;

  ReadVideo(this.docRef, this.stream);
  @override
  _ReadVideoState createState() => _ReadVideoState(docRef, stream);
}

class _ReadVideoState extends State<ReadVideo>
    with AutomaticKeepAliveClientMixin {
  final String docRef;
  VideoPlayerController _controller;

  final Stream<DocumentSnapshot> _stream;
  _ReadVideoState(this.docRef, this._stream);
  double currentPosition = 0;
  Future<void> _initializeVideoPlayerFuture;
  String url;

  @override
  void initState() {
    getVideo();
    super.initState();
  }

  Future<void> getVideo() async {
    url = await FirebaseStorage.instance.ref().child(docRef).getDownloadURL();
    _controller = VideoPlayerController.network(url);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(looping);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorMessage(snapshot.error);
        }
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return ReadDecoration(
              height: 500,
              child: Column(
                children: <Widget>[
                  (_controller != null)
                      ? MyVideoPlayer(_controller, 365, 330)
                      : Container(child: CircularProgressIndicator()),
                  StreamBuilder<DocumentSnapshot>(
                      stream: _stream,
                      builder: (context, snaps) {
                        if (snapshot.hasError) {
                          return ErrorMessage(snapshot.error);
                        }
                        switch (snaps.connectionState) {
                          case ConnectionState.active:
                            return CommentBar(
                                '${snaps.data['likes']}',
                                '${snaps.data['dislikes']}',
                                '${snaps.data['comments']}',
                                context,
                                docRef,
                                'videos',
                                url);
                          default:
                            return Container();
                        }
                      })
                ],
              ),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }
    _initializeVideoPlayerFuture = null;
    url = null;
    super.dispose();
  }
}
