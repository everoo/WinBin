import 'package:flutter/material.dart';

class MyPictureHolder extends StatefulWidget {
  final double height;
  final double width;
  final Size imageSize;
  final Image image;

  const MyPictureHolder(
      {Key key, this.height, this.width, this.imageSize, this.image})
      : super(key: key);

  @override
  _MyPictureHolderState createState() =>
      _MyPictureHolderState(height, width, imageSize, image);
}

class _MyPictureHolderState extends State<MyPictureHolder> {
  final double height;
  final double width;
  final Size imageSize;
  Image image;

  double _angle = 0;
  double _scale = 1;
  Offset _point = Offset(0, 0);
  List<ScaleUpdateDetails> ds = [
    ScaleUpdateDetails(),
    ScaleUpdateDetails(),
    ScaleUpdateDetails()
  ];

  _MyPictureHolderState(this.height, this.width, this.imageSize, this.image);
  int countSwitch = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (_scale == 1) {
          if (imageSize.aspectRatio > 1) {
            _scale = (imageSize.longestSide / imageSize.shortestSide) *
                (height / width) *
                1.02;
          } else {
            _scale = (imageSize.longestSide / imageSize.shortestSide) *
                (width / height) /
                1.02;
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
      child: Container(
        color: Colors.transparent,
        height: height,
        width: width,
        child: Container(
          width: width,
          height: height,
          child: ClipRect(
            child: Transform.translate(
              child: Transform.scale(
                child: Transform.rotate(
                  child: image,
                  angle: _angle,
                ),
                scale: _scale,
              ),
              offset: _point,
            ),
          ),
        ),
      ),
    );
  }
}
