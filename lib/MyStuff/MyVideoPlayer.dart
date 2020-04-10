import 'dart:async';

import 'package:Archive/MyStuff/LoadingIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
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

class _MyVideoPlayerState extends State<MyVideoPlayer>
    with SingleTickerProviderStateMixin {
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
  AnimationController _anime;
  Animation<Offset> _ani;

  void _runAnimation(Offset end) {
    _ani = _anime.drive(
      Tween(
        begin: _point,
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
  }

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
    _anime = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(seconds: 1),
    );
    _anime.addListener(animate);
  }

  animate() => setState(() => _point = _ani.value);

  double _opacity = 0;

  showLoop() {
    _opacity = 1;
    Timer(Duration(milliseconds: 500), () => setState(() => _opacity = 0));
  }

  @override
  void dispose() {
    _anime.removeListener(animate);
    _anime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return Container();
    player = VideoPlayer(_controller);
    return GestureDetector(
      onDoubleTap: () {
        if (_scale == 1) {
          if (_controller.value.size.aspectRatio > this.width / this.height) {
            _scale = (_controller.value.size.width /
                    (_controller.value.size.height - 15)) *
                ((this.height-40) / this.width);
          } else {
            _scale =
                (_controller.value.size.height / _controller.value.size.width) *
                    (this.width / (this.height-40));
          }
        } else {
          _scale = 1;
        }
        _angle = 0;
        _runAnimation(Offset.zero);
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
      onScaleEnd: (s) {
        Offset _tmp = _point;
        Offset pps = s.velocity.pixelsPerSecond;
        _runAnimation(Offset(_tmp.dx + pps.dx / 7, _tmp.dy + pps.dy / 7));
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
        showLoop();
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: height,
            child: ListView(
              padding: EdgeInsets.zero,
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
                              child: (_controller.value.initialized)
                                  ? player
                                  : LoadingIcon(0, 1),
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
                              ? _controller.value.duration.inMilliseconds
                                  .toDouble()
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
          Center(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _opacity,
              child: Stack(
                children: <Widget>[
                  Center(
                      child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0x44000000)),
                  )),
                  (!_controller.value.isLooping)
                      ? Center(child: Icon(Icons.block, size: 34))
                      : Container(),
                  Center(
                      child: Icon(Icons.replay,
                          size: (_controller.value.isLooping) ? 34 : 22)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
