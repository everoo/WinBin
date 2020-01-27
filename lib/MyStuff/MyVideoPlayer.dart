import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:winbin/Globals.dart';

class MyVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final double height;
  final double width;

  MyVideoPlayer(this.controller, this.height, this.width);

  @override
  _MyVideoPlayerState createState() =>
      _MyVideoPlayerState(controller, height, width);
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  VideoPlayerController _controller;
  double currentPosition = 0;
  final double height;
  final double width;
  VoidCallback listener;
  VideoPlayer player;

  _MyVideoPlayerState(this._controller, this.height, this.width);


  //Make it so there is only one video player controller on the home screen
  //basically it would wait until there was ten seconds left in the video
  //Then load the next one in the stream, all i store is the url and have one controller per tab
  //and a stream list that is jsut the video urls, create a new  
  //have a boolean list of video that swaps between [null, Video.network(url)] and [Video.network(url), null]

  @override
  void initState() {
    listener = () {
      Timer.run(() {
        setState(() {
          if (_controller.value.duration != null) {
            if (_controller.value.position.inMilliseconds.toDouble() >
                _controller.value.duration.inMilliseconds.toDouble()) {
              currentPosition =
                  _controller.value.duration.inMilliseconds.toDouble();
            } else if (_controller.value.position.inMilliseconds.toDouble() <
                0) {
              currentPosition = 0;
            } else {
              currentPosition =
                  _controller.value.position.inMilliseconds.toDouble();
            }
          }
        });
      });
    };
    _controller.addListener(listener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    player = VideoPlayer(_controller);
    return (_controller.value != null)
        ? Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  lightImpact();
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
                onLongPress: () {
                  _controller.setLooping(looping);
                },
                child: Container(
                  height: height,
                  width: width,
                  margin: EdgeInsets.fromLTRB(12, 12, 12, 2),
                  child: player,
                ),
              ),
              Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        right: (leftHanded) ? 0 : 70,
                        left: (leftHanded) ? 70 : 0),
                    width: width * 5 / 5 - 2,
                    child: Slider(
                      max: (_controller.value.duration != null)
                          ? _controller.value.duration.inMilliseconds.toDouble()
                          : 1,
                      onChanged: (d) {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          }
                          if (_controller.value.duration != null) {
                            if (d >
                                _controller.value.duration.inMilliseconds
                                    .toDouble()) {
                              currentPosition = _controller
                                  .value.duration.inMilliseconds
                                  .toDouble();
                            } else if (d < 0) {
                              currentPosition = 0;
                            } else {
                              currentPosition = d;
                            }
                          }
                          Timer.run(() {
                            _controller
                                .seekTo(Duration(
                                    milliseconds: currentPosition.toInt()))
                                .whenComplete(() {
                              setState(() {
                                _controller
                                    .play()
                                    .whenComplete(_controller.pause);
                              });
                            });
                          });
                        });
                      },
                      value: currentPosition,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: (leftHanded) ? 15 : 275),
                    child: Text(
                      (_controller.value.duration != null)
                          ? '${_controller.value.position.toString().substring(3, 7)}/${_controller.value.duration.toString().substring(3, 7)}'
                          : '0:00/0:00',
                      style: themeData.textTheme.title,
                    ),
                  )
                ],
              ),
            ],
          )
        : Container();
  }

  @override
  void dispose() {
    player = null;
    if (_controller != null) {
      _controller.dispose();
      _controller.removeListener(listener);
      _controller = null;
    }
    super.dispose();
  }
}
