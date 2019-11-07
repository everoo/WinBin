import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:winbin/main.dart';

class CreateMeme extends StatefulWidget {
  @override
  _CreateMemeState createState() => _CreateMemeState();
}

class _CreateMemeState extends State<CreateMeme> {
  File _image;
  Future getImage(bool usesCamera) async {
    File image;
    if (usesCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 522,
      child: Center(
        child: (_image == null)
            ? ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(77, 30, 77, 20),
                    child: RaisedButton(
                      elevation: 4,
                      color: themeData.backgroundColor,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod<void>('HapticFeedback.vibrate');
                        getImage(true);
                      },
                      child: Container(
                        height: 220,
                        width: 190,
                        child: Icon(
                          Icons.photo_camera,
                          size: 52,
                          color: themeData.textTheme.title.color,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(77, 0, 77, 20),
                    child: RaisedButton(
                      elevation: 4,
                      color: themeData.backgroundColor,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod<void>('HapticFeedback.vibrate');
                        getImage(false);
                      },
                      child: Container(
                        height: 220,
                        width: 190,
                        child: Icon(
                          Icons.apps,
                          size: 52,
                          color: themeData.textTheme.title.color,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 4),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          offset: Offset.fromDirection(1, 3),
                          color: Color(0x55000000),
                          blurRadius: 2,
                          spreadRadius: 2)
                    ], color: Colors.transparent),
                    child: Image.file(_image),
                  ),
                  RaisedButton(
                    onPressed: null,
                    child: Icon(Icons.crop),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(135, 10, 135, 10),
                    child: Container(
                      width: 100,
                      height: 100,
                      child: RaisedButton(
                        color: Color(0xFFFF77FF),
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: submit,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                          child: Icon(
                            Icons.file_upload,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
//         .
//       .
//     .
//   .
//       ^    .
//      /
//     /_

  //mimcs sin wave
  //you have atotal of five points on a graph, imagine these are on a wheel sepearted by an equal distance so that as the wheel rolls each point is on the graph once. (call it a timestep)
  //you know which timestep you want the fifth point( not on the wheel) to land on
  //the angle to make both dots land on the same timestep depends on which timestep it is.

  //have a wheel with a stick on the end of it that when the wheel rolls around the other end is heavy and as gravity reverses it falls back down causing the stick to hit the ground and cause the wheel to move again.
  //gravity is the answeer to infinite energy because of a blackhole can do it we can simplify it down and make it not use the enitre rotation around the object
  //there has to be a way to shortcut gravity poassibly with multiple things pivoting because of gravity and different weights on each, that way the wheel only moves so much of the heavy weight.

  void submit() {
    int currentTime = Timestamp.now().seconds;
    FirebaseStorage.instance
        .ref()
        .child('images-${currentUser.uid}-$currentTime')
        .putFile(_image);
    Firestore.instance
        .collection('images')
        .document('images-${currentUser.uid}-$currentTime')
        .setData({
      'likes': 0,
      'comments': 0,
      'dislikes': 0,
    });
    Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('posts')
        .document('images-${currentUser.uid}-$currentTime')
        .setData({
      'type': 'images',
    });
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(Firestore.instance
          .collection('all')
          .document('${Timestamp.now().toDate()}'.substring(0, 10)));
      await transaction.update(freshSnap.reference, {
        '${(freshSnap.data == null) ? 0 : freshSnap.data.length - 1}':
            'images-${currentUser.uid}-$currentTime'
      });
    });
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(
          Firestore.instance.collection('users').document(currentUser.uid));
      List<dynamic> list = List.from(freshSnap.data['posts']);
      list.add('images-${currentUser.uid}-$currentTime');
      await transaction.update(
        freshSnap.reference,
        <String, dynamic>{
          'posts': list,
        },
      );
    });

    setState(() {
      _image = null;
    });
  }
}
