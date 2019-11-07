import 'package:flutter/material.dart';

class ReadVideo extends StatefulWidget {
  final String docRef;

  const ReadVideo({Key key, this.docRef}) : super(key: key);
  @override
  _ReadVideoState createState() => _ReadVideoState();
}

class _ReadVideoState extends State<ReadVideo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}