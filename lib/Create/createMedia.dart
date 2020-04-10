import 'package:Archive/MyStuff/MyVideoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Archive/Globals.dart';
import 'package:Archive/MyStuff/MyPictureHolder.dart';
import 'package:Archive/MyStuff/MySubmitBar.dart';
import 'package:video_player/video_player.dart';

class CreateMedia extends StatefulWidget {
  final bool image;
  CreateMedia(this.image);
  @override
  _CreateMediaState createState() => _CreateMediaState();
}

class _CreateMediaState extends State<CreateMedia> {
  VideoPlayerController _controller;
  Image _image;

  Size fileSize;
  bool tooBig = false;
  bool visible = false;

  Future getMedia(bool usesCamera) async {
    if (widget.image) {
      file = await ImagePicker.pickImage(
          source: (usesCamera) ? ImageSource.camera : ImageSource.gallery);
    } else {
      file = await ImagePicker.pickVideo(
          source: (usesCamera) ? ImageSource.camera : ImageSource.gallery);
    }
    if (file != null) {
      if (widget.image) {
        var stats = await decodeImageFromList(file.readAsBytesSync());
        fileSize = Size(stats.width.toDouble(), stats.height.toDouble());
        _image = Image.file(file, scale: 1.5, fit: BoxFit.scaleDown);
      } else {
        _controller = VideoPlayerController.file(file);
        _controller.initialize();
        _controller.setLooping(looping);
      }
    }
    file.stat().then((d) {
      if (d.size > 25000000) tooBig = true;
    });
    setState(() {
      visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.85,
      child: (file == null || !visible)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.fromLTRB(0, height * 0.01, 0, height * 0.01),
                  width: height * 0.50,
                  height: height * 0.50,
                  child: RaisedButton(
                    elevation: 9,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: themeData.backgroundColor,
                    padding: EdgeInsets.all(height * 0.01),
                    onPressed: () {
                      heavyImpact();
                      getMedia(false);
                    },
                    child: Icon(
                      Icons.apps,
                      size: 100,
                      color: themeData.textTheme.headline6.color,
                    ),
                  ),
                ),
                Container(
                  width: height * 0.31,
                  height: height * 0.31,
                  child: RaisedButton(
                    padding: EdgeInsets.all(height * 0.01),
                    elevation: 9,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    color: themeData.backgroundColor,
                    onPressed: () {
                      lightImpact();
                      getMedia(true);
                    },
                    child: Icon(
                      Icons.camera_alt,
                      size: 60,
                      color: themeData.textTheme.headline6.color,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ReadDecoration(
                      height: height * 0.64,
                      margin: EdgeInsets.fromLTRB(width * 0.02, height * 0.01,
                          width * 0.02, height * 0.01),
                      child: (widget.image)
                          ? MyPictureHolder(
                              image: _image,
                              height: height * 0.64,
                              width: width * 0.98,
                              imageSize: fileSize,
                            )
                          : MyVideoPlayer(
                              _controller, height * 0.64, width * 0.98),
                    ),
                    (tooBig)
                        ? IconButton(
                            splashColor: Colors.transparent,
                            onPressed: () {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                'File is too big. Max is 25 MB.',
                                textAlign: TextAlign.center,
                              )));
                            },
                            icon: Icon(Icons.error),
                            color: Color(0xAAFF0000),
                          )
                        : Container(),
                  ],
                ),
                SubmitBar([
                  [
                    () {
                      submit(
                          context: context,
                          file: file,
                          type: (widget.image) ? 'images' : 'videos',
                          data: (widget.image)
                              ? {
                                  'width': fileSize.width,
                                  'height': fileSize.height
                                }
                              : {},
                          func: delete,
                          available: !tooBig,
                          funcA: () => setState(() => visible = false));
                    },
                    Icon(
                      Icons.file_upload,
                      color: themeData.textTheme.headline6.color,
                    ),
                  ],
                  [
                    delete,
                    Icon(Icons.clear,
                        color: themeData.textTheme.headline6.color)
                  ],
                ]),
              ],
            ),
    );
  }

  delete() {
    lightImpact();
    setState(() {
      if (file != null) {
        tooBig = false;
        if (_image != null) _image.image.evict();
        if (_controller != null) _controller.stop();
        _image = null;
        _controller = null;
        file.delete().catchError((e) {});
        file = null;
        visible = false;
      }
    });
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    if (_image != null) _image.image.evict();
    if (file != null) file.delete().catchError((e) {});
    super.dispose();
  }
}
