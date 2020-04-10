import 'dart:io';
import 'package:Archive/MyStuff/TagList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';

List<String> _createFilters = [];

class SubmitBar extends StatefulWidget {
  final List actionIcon;
  final Size size;
  final EdgeInsetsGeometry margin;
  final List specialButton;
  SubmitBar(this.actionIcon, {this.size, this.margin, this.specialButton});

  @override
  _SubmitBarState createState() =>
      _SubmitBarState(actionIcon, size: size, margin: margin);
}

class _SubmitBarState extends State<SubmitBar> {
  bool showing = true;
  List actionIcon;
  List ll = [];
  Size size;
  EdgeInsetsGeometry margin;

  _SubmitBarState(this.actionIcon, {this.size, this.margin});

  @override
  void initState() {
    if (!leftHanded) {
      actionIcon = actionIcon.reversed.toList();
    }
    if (margin == null) {
      margin = EdgeInsets.fromLTRB(width * 0.02, 0, width * 0.02, 0);
    } else {
      showing = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) {
      size = Size(width * 0.96, height * 0.13);
    }
    ll = [
      [
        () => setState(() => sfw = !sfw),
        Column(
          children: <Widget>[
            Icon((sfw) ? Icons.check : Icons.block,
                size: width * 0.06, color: themeData.textTheme.headline6.color),
            Text((sfw) ? 'SFW' : 'NSFW',
                style: TextStyle(color: themeData.textTheme.headline6.color)),
          ],
        ),
      ],
      [
        askForComment,
        Icon(Icons.add_comment, color: themeData.textTheme.headline6.color),
      ],
      [
        askForTags,
        Icon(Icons.add_circle, color: themeData.textTheme.headline6.color),
      ]
    ];
    if (widget.specialButton!=null) {
      ll.add(widget.specialButton);
    }
    if (!leftHanded) {
      ll = ll.reversed.toList();
    }
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: (showing) ? height * 0.045 : 0),
          child: ReadDecoration(
            margin: margin,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                for (List v in actionIcon)
                  Row(
                    children: <Widget>[
                      Container(
                        width: size.width / actionIcon.length -
                            actionIcon.length +
                            1,
                        height: size.height,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: (v == actionIcon.first)
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      topLeft: Radius.circular(25))
                                  : (v == actionIcon.last)
                                      ? BorderRadius.only(
                                          bottomRight: Radius.circular(25),
                                          topRight: Radius.circular(25))
                                      : BorderRadius.only()),
                          onPressed: v[0],
                          child: v[1],
                        ),
                      ),
                      (v != actionIcon.last)
                          ? Container(
                              height: size.height * 3 / 5,
                              width: 1,
                              color: themeData.scaffoldBackgroundColor,
                            )
                          : Container(),
                    ],
                  ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (var l in ll)
              (showing)
                  ? Container(
                      height: width * 0.11,
                      width: width * 0.2,
                      child: RaisedButton(
                        elevation: 3,
                        color: themeData.scaffoldBackgroundColor,
                        onPressed: l[0],
                        child: l[1],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 0.06)),
                      ),
                    )
                  : Container(),
          ],
        ),
      ],
    );
  }

  askForComment() {
    showDialog<bool>(
      context: context,
      builder: (con) {
        return AlertDialog(
          backgroundColor: themeData.secondaryHeaderColor,
          title: Text(
            'Leave the first comment, or leave it blank.',
            textAlign: TextAlign.center,
            style: themeData.textTheme.headline6,
          ),
          content: TextField(
            controller: cont,
            autofocus: true,
            style: themeData.textTheme.headline6,
            textAlign: TextAlign.center,
            onSubmitted: (s) => Navigator.of(context).pop(),
          ),
          actionsPadding: EdgeInsets.only(right: width * 0.28),
        );
      },
    );
  }

  askForTags() {
    showDialog<bool>(
      context: context,
      builder: (con) => Dialog(
        backgroundColor: themeData.backgroundColor,
        child: Container(
            height: height * 0.3,
            child: TagList(
                _createFilters,
                (List<String> _, List<int> _n) => _createFilters = _,
                () => _createFilters = [],
                'Add Tags to Your Post')),
      ),
    );
  }
}

Future submit(
    {BuildContext context,
    String type,
    Map<String, dynamic> data,
    VoidCallback func,
    VoidCallback funcA,
    bool available = true,
    File file}) async {
  var _date = DateTime.now().toUtc();

  if (available) {
    lightImpact();
    var currentTime =
        '$_date'.substring(0, 19).replaceAll('-', '').replaceAll(' ', '');
    data.addAll({
      'sfw': sfw,
      'likes': {myID: true},
      'tags': _createFilters
    });
    if ((cont.text ?? '').replaceAll(' ', '') != '') {
      data.addAll({
        '$_date'.replaceAll('.', ''): [
          cont.text,
          {myID: true}
        ]
      });
    }
    sfw = true;
    cont.clear();
    _createFilters = [];
    if (data.containsKey('sfw')) {
      if (funcA != null) funcA();
      if (file != null) {
        await FirebaseStorage.instance
            .ref()
            .child('$_date'.substring(0, 4))
            .child('$_date'.substring(5, 7))
            .child('$_date'.substring(0, 10))
            .child('$currentTime-$type-$myID')
            .putFile(file)
            .onComplete
            .then((d) {
          d.ref.getDownloadURL().then((ur) {
            data.addAll({'url': ur});
            Firestore.instance
                .collection('$_date'.substring(0, 10))
                .document('$currentTime-$type-$myID')
                .setData(data);
          });
        });
      } else {
        await Firestore.instance
            .collection('$_date'.substring(0, 10))
            .document('$currentTime-$type-$myID')
            .setData(data);
      }
      func();
      heavyImpact();
    }
  } else {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        'Can\'t currently upload.',
        textAlign: TextAlign.center,
      ),
    ));
  }
}
