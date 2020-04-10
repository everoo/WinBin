import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

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

class _MyPictureHolderState extends State<MyPictureHolder>
    with SingleTickerProviderStateMixin {
  final double height;
  final double width;
  final Size imageSize;
  final Image image;

  double _angle = 0;
  double _scale = 1;
  Offset _point = Offset(0, 0);
  List<ScaleUpdateDetails> ds = [
    ScaleUpdateDetails(),
    ScaleUpdateDetails(),
    ScaleUpdateDetails()
  ];

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

  _MyPictureHolderState(this.height, this.width, this.imageSize, this.image);
  int countSwitch = 0;

  @override
  void initState() {
    super.initState();
    _anime = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(seconds: 1),
    );
    _anime.addListener(animate);
  }

  animate() => setState(() => _point = _ani.value);

  @override
  void dispose() {
    _anime.removeListener(animate);
    _anime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Image == null) return Container();
    return GestureDetector(
      onDoubleTap: () {
        if (_scale == 1) {
          if (imageSize.aspectRatio > this.width / this.height) {
            _scale = (imageSize.width / (imageSize.height - 15)) *
                (this.height / this.width);
          } else {
            _scale = (imageSize.height / imageSize.width) *
                (this.width / this.height);
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
      child: Container(
        height: height,
        width: width,
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
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
    );
  }
}
