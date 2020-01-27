import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:winbin/Globals.dart';
import 'package:winbin/MyStuff/MyPictureHolder.dart';
import 'package:winbin/MyStuff/MySubmitBar.dart';

class CreateMeme extends StatefulWidget {
  @override
  _CreateMemeState createState() => _CreateMemeState();
}

class _CreateMemeState extends State<CreateMeme> {
  File _image;
  Size _imageSize;
  SubmitBar _bar;

  Future getImage(bool usesCamera) async {
    if (usesCamera) {
      _image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    var stats = await decodeImageFromList(_image.readAsBytesSync());
    setState(() {
      _imageSize = Size(stats.width.toDouble(), stats.height.toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560,
      child: (_image == null)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
                  width: 340,
                  height: 340,
                  child: RaisedButton(
                    elevation: 9,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: themeData.backgroundColor,
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      heavyImpact();
                      getImage(false);
                    },
                    child: Icon(
                      Icons.apps,
                      size: 100,
                      color: themeData.textTheme.title.color,
                    ),
                  ),
                ),
                Container(
                  width: 290,
                  height: 190,
                  child: RaisedButton(
                    padding: EdgeInsets.all(10),
                    elevation: 9,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    color: themeData.backgroundColor,
                    onPressed: () {
                      lightImpact();
                      getImage(true);
                    },
                    child: Icon(
                      Icons.camera_alt,
                      size: 60,
                      color: themeData.textTheme.title.color,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        offset: Offset.fromDirection(1, 3),
                        color: Color(0x55000000),
                        blurRadius: 2,
                        spreadRadius: 2)
                  ], color: Colors.transparent),
                  child: MyPictureHolder(
                    image: Image.file(
                      _image,
                      scale: 1.5,
                      fit: BoxFit.scaleDown,
                    ),
                    height: 453,
                    width: 350,
                    imageSize: _imageSize,
                  ),
                ),
                _bar = SubmitBar([
                  [
                    () {
                      _bar.submit(_image, 'images', {
                        'likes': 0,
                        'comments': 0,
                        'dislikes': 0,
                        'width': _imageSize.width,
                        'height': _imageSize.height
                      }, () {
                        this.setState(() {
                          if (_image != null) {
                            _image.delete();
                            _image = null;
                          }
                        });
                      }, _image != null);
                    },
                    Icon(
                      Icons.file_upload,
                      color: themeData.textTheme.title.color,
                    ),
                  ],
                  [
                    () {
                      lightImpact();
                      setState(() {
                        if (_image != null) {
                          _image.delete();
                          _image = null;
                        }
                      });
                    },
                    Icon(
                      Icons.clear,
                      color: themeData.textTheme.title.color,
                    ),
                  ],
                ]),
              ],
            ),
    );
  }

  @override
  void dispose() {
    if (_image != null) {
      _image.delete();
      _image = null;
    }
    super.dispose();
  }
}
