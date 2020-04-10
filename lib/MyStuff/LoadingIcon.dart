import 'package:Archive/Globals.dart';
import 'package:flutter/material.dart';

class LoadingIcon extends StatefulWidget {
  final int max;
  final int current;
  LoadingIcon(this.current, this.max);

  @override
  _LoadingIconState createState() => _LoadingIconState();
}

class _LoadingIconState extends State<LoadingIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _anime;
  Animation<Offset> _ani;
  Offset _point = Offset(0, height * -0.275 + 20);

  @override
  void initState() {
    super.initState();
    _anime = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(seconds: 1),
    );
    _anime.addListener(animate);
    loopAni();
  }

  loopAni() {
    Duration _dur = Duration(
        milliseconds: ((1.01 - widget.current / widget.max) * 800).toInt());
    _anime.animateTo(1, curve: Curves.easeIn, duration: _dur).whenComplete(() =>
        _anime
            .animateBack(0, curve: Curves.easeOut, duration: _dur)
            .whenComplete(loopAni));
  }

  @override
  void dispose() {
    _anime.removeListener(animate);
    _anime.dispose();
    super.dispose();
  }

  animate() => setState(() => _point = _ani.value);

  @override
  Widget build(BuildContext context) {
    _ani = _anime.drive(
      Tween(
        begin: Offset(
            0,
            ((1 - widget.current / widget.max) * height * -0.55 - 40) +
                (height * 0.275 - 20)),
        end: Offset(0, height * 0.275 - 20),
      ),
    );
    return Transform.translate(
      offset: _point,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: themeData.colorScheme.onSecondary,
          ),
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}

class DragIndicator extends StatefulWidget {
  @override
  _DragIndicatorState createState() => _DragIndicatorState();
}

class _DragIndicatorState extends State<DragIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _anime;
  Animation<double> _ani;
  double _point = 0.6;

  @override
  void initState() {
    super.initState();
    _anime = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(seconds: 1),
    );
    _ani = _anime.drive(
      Tween(
        begin: 0.6,
        end: 0.3,
      ),
    );
    _anime.addListener(animate);
    loopAni();
  }

  loopAni() {
    Duration _dur = Duration(milliseconds: 800);
    _anime.animateTo(1, curve: Curves.easeInOut, duration: _dur).whenComplete(() =>
        _anime
            .animateBack(0, curve: Curves.easeInOut, duration: _dur)
            .whenComplete(loopAni));
  }

  @override
  void dispose() {
    _anime.removeListener(animate);
    _anime.dispose();
    super.dispose();
  }

  animate() => setState(() => _point = _ani.value);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(width * _point, height * 0.7),
      child: Icon(
        Icons.touch_app,
        color: themeData.colorScheme.primary,
        size: 30,
      ),
    );
  }
}
