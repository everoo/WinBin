import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:Archive/Globals.dart';

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
  final VideoPlayerController _controller;
  double currentPosition = 0;
  final double height;
  final double width;
  VoidCallback listener;
  VideoPlayer player;

  _MyVideoPlayerState(this._controller, this.height, this.width);

  double _angle = 0;
  double _scale = 1;
  Offset _point = Offset(0, 0);
  List<ScaleUpdateDetails> ds = [
    ScaleUpdateDetails(),
    ScaleUpdateDetails(),
    ScaleUpdateDetails()
  ];
  int countSwitch = 0;

  @override
  void initState() {
    listener = () {
      Timer.run(() {
        if (_controller.value.duration != null) {
          setState(() {
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
          });
        }
      });
    };
    if (_controller != null) {
      _controller.removeListener(listener);
      _controller.addListener(listener);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return Container();
    player = VideoPlayer(_controller);
    return GestureDetector(
      onDoubleTap: () {
        if (_scale == 1) {
          if (_controller.value.size.aspectRatio > width / (height - 40)) {
            _scale =
                (_controller.value.size.width / _controller.value.size.height) *
                    ((height - 40) / width);
          } else {
            _scale =
                (_controller.value.size.height / _controller.value.size.width) *
                    (width / (height - 40));
          }
        } else {
          _scale = 1;
        }
        _angle = 0;
        _point = Offset.zero;
        setState(() {});
      },
      onScaleStart: (d) {
        countSwitch = 0;
      },
      onScaleUpdate: (d) {
        ds.insert(0, d);
        double deltaRotation = 0;
        double deltaScale = 0;
        Offset deltaTrans = Offset(ds[1].focalPoint.dx - ds[2].focalPoint.dx,
            ds[1].focalPoint.dy - ds[2].focalPoint.dy);
        if (countSwitch > 3) {
          deltaRotation = ds[1].rotation - ds[2].rotation;
          deltaScale = ds[1].scale - ds[2].scale;
          _point = Offset(
              _point.dx + deltaTrans.dx * 1.5, _point.dy + deltaTrans.dy * 1.5);
        } else {
          countSwitch += 1;
        }
        _angle += deltaRotation;
        _scale += deltaScale * 1.2;
        setState(() {});
        ds.removeLast();
      },
      onTap: () {
        lightImpact();
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          if (_controller.value.duration == _controller.value.position) {
            _controller.seekTo(Duration(seconds: 0));
          }
          _controller.play();
        }
      },
      onLongPress: () {
        lightImpact();
        _controller.setLooping(!_controller.value.isLooping);
      },
      child: Container(
        height: height,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              height: height - 40,
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Transform.translate(
                  child: Transform.scale(
                    child: Transform.rotate(
                      child: Align(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: player,
                        ),
                      ),
                      angle: _angle,
                    ),
                    scale: _scale,
                  ),
                  offset: _point,
                ),
              ),
            ),
            Container(
              height: 40,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        right: (leftHanded) ? 0 : width * 0.2,
                        left: (leftHanded) ? width * 0.2 : 0),
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
                    padding: EdgeInsets.only(
                        left: (leftHanded) ? width * 0.04 : width * 0.76),
                    child: Text(
                      (_controller.value.duration != null)
                          ? '${_controller.value.position.toString().substring(3, 7)}/${_controller.value.duration.toString().substring(3, 7)}'
                          : '0:00/0:00',
                      style: themeData.textTheme.headline6,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
