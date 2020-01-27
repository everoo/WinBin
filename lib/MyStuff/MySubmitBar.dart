import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Globals.dart';

class SubmitBar extends StatelessWidget {
  List actionIcon;
  Size size;
  EdgeInsetsGeometry margin;
  SubmitBar(this.actionIcon, {this.size, this.margin});

  @override
  Widget build(BuildContext context) {
    if (!leftHanded) {
      actionIcon = actionIcon.reversed.toList();
    }
    if (size == null) {
      size = Size(352, 85);
    }
    if (margin == null) {
      margin = EdgeInsets.fromLTRB(12, 0, 12, 0);
    }
    return ReadDecoration(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          for (List v in actionIcon)
            Row(
              children: <Widget>[
                Container(
                  width: size.width / actionIcon.length - actionIcon.length + 1,
                  height: size.height,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: (v == actionIcon.first)
                            ? BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                topLeft: Radius.circular(30))
                            : (v == actionIcon.last)
                                ? BorderRadius.only(
                                    bottomRight: Radius.circular(30),
                                    topRight: Radius.circular(30))
                                : BorderRadius.only()),
                    onPressed: v[0],
                    child: v[1],
                  ),
                ),
                (v != actionIcon.last)
                    ? Container(
                        height: size.height*3/5,
                        width: 1,
                        color: themeData.scaffoldBackgroundColor,
                      )
                    : Container(),
              ],
            ),
        ],
      ),
    );
  }

  Future submit(File file, String type, Map<String, dynamic> data,
      VoidCallback func, bool available) async {
    if (available) {
      vibrate();
      int currentTime = Timestamp.now().seconds;
      print(file);
      if (file != null) {
        FirebaseStorage.instance
            .ref()
            .child('$currentTime-$type-$myID')
            .putFile(file);
        file.delete();
        print(file);
      }
      await Firestore.instance
          .collection(type)
          .document('$currentTime-$type-$myID')
          .setData(data);
      await Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(Firestore.instance
            .collection(currentBoard)
            .document('${Timestamp.now().toDate()}'.substring(0, 10)));
        await transaction.update(freshSnap.reference, {
          '${(freshSnap.data == null) ? 0 : freshSnap.data.length - 1}':
              '$currentTime-$type-$myID}'
        });
      });
      func();
    }
  }
}
