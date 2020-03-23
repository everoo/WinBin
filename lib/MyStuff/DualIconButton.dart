import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';

class DualIconButton extends StatelessWidget {
  final Size size;
  final EdgeInsetsGeometry margin;
  final VoidCallback action;
  final VoidCallback actionA;
  final Widget icon;
  DualIconButton(
      {Key key, this.size, this.action, this.icon, this.actionA, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      margin: margin,
      child: RaisedButton(
        elevation: 9,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        color: themeData.secondaryHeaderColor,
        child: icon,
        onPressed: action,
        onLongPress: actionA,
      ),
    );
  }
}