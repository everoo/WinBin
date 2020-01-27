import 'package:flutter/material.dart';

class Read extends StatefulWidget {
  final int spot;

  Read(this.spot);

  @override
  _ReadState createState() => _ReadState(spot);
}

class _ReadState extends State<Read> {
  final int spot;

  _ReadState(this.spot);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
