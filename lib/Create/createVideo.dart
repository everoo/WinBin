import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart'; ////
import 'package:winbin/Globals.dart';
import 'package:winbin/MyStuff/MySubmitBar.dart';
import 'package:winbin/MyStuff/MyVideoPlayer.dart';

class CreateVideo extends StatefulWidget {
  @override
  _CreateVideoState createState() => _CreateVideoState();
}

class _CreateVideoState extends State<CreateVideo> {
  VideoPlayerController _controller;
  File file;
  SubmitBar _bar;

  void getVid(bool cam) async {
    if (_controller != null) {
      _controller = null;
      file.deleteSync();
      //file = null;
    }
    if (cam) {
      file = await ImagePicker.pickVideo(source: ImageSource.gallery);
    } else {
      file = await ImagePicker.pickVideo(source: ImageSource.camera);
    }
    if (file != null) {
      _controller = VideoPlayerController.file(file);
      _controller.initialize();
      _controller.setLooping(looping);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Container(
        width: 300,
        height: 555,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
              width: 340,
              height: 340,
              child: RaisedButton(
                elevation: 9,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: themeData.backgroundColor,
                padding: EdgeInsets.all(10),
                onPressed: () {
                  heavyImpact();
                  getVid(true);
                },
                child: Icon(
                  Icons.local_movies,
                  size: 100,
                  color: themeData.textTheme.title.color,
                ),
              ),
            ),
            Container(
              width: 290,
              height: 190,
              child: RaisedButton(
                padding: EdgeInsets.all(10),
                elevation: 9,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: themeData.backgroundColor,
                onPressed: () {
                  lightImpact();
                  getVid(false);
                },
                child: Icon(
                  Icons.camera_alt,
                  size: 60,
                  color: themeData.textTheme.title.color,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset.fromDirection(1, 3),
                            color: Color(0x55000000),
                            blurRadius: 2,
                            spreadRadius: 2)
                      ],
                      color: themeData.backgroundColor,
                      borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 5),
                  child: MyVideoPlayer(_controller, 398, 350)),
            ],
          ),
          _bar = SubmitBar([
            [
              () {
                _bar.submit(file, 'videos', {
                  'likes': 0,
                  'comments': 0,
                  'dislikes': 0,
                }, () {
                  setState(() {
                    file.delete();
                    //file = null;
                    _controller = null;
                  });
                }, file != null);
              },
              Icon(
                Icons.file_upload,
                color: themeData.textTheme.title.color,
              ),
            ],
            [
              () {
                lightImpact();
                setState(() {
                  _controller = null;
                  file.delete();
                  //file = null;
                });
              },
              Icon(
                Icons.clear,
                color: themeData.textTheme.title.color,
              ),
            ],
          ]),
        ],
      );
    }
  }

  @override
  void dispose() {
    if (file != null) {
      file.delete();
      //file = null;
    }
    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }
    super.dispose();
  }
}
