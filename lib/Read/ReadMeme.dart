import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Comments/CommentBar.dart';
import 'package:winbin/Globals.dart';
import 'package:winbin/MyStuff/MyPictureHolder.dart';

class ReadMeme extends StatefulWidget {
  final String docRef;
  final Stream<DocumentSnapshot> stream;

  ReadMeme(this.docRef, this.stream);
  @override
  _ReadMemeState createState() => _ReadMemeState(docRef, stream);
}

class _ReadMemeState extends State<ReadMeme>
    with AutomaticKeepAliveClientMixin {
  final String docRef;
  final Stream<DocumentSnapshot> _stream;
  String url;
  Image _image;

  _ReadMemeState(this.docRef, this._stream);

  @override
  void initState() {
    getUrl();
    super.initState();
  }

  void getUrl() async {
    url = await FirebaseStorage.instance.ref().child(docRef).getDownloadURL();
    _image = Image.network(
      url,
      fit: BoxFit.scaleDown,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorMessage(snapshot.error);
        }
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (snapshot.data != null) {
              if (snapshot.data.data != null) {
                return ReadDecoration(
                  height: 500,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.5, 10, 12.5, 0),
                        child: (url == null)
                            ? Container(
                                height: 415,
                              )
                            : MyPictureHolder(
                                width: 340,
                                height: 415,
                                imageSize: Size(snapshot.data['width'],
                                    snapshot.data['height']),
                                image: _image,
                              ),
                      ),
                      CommentBar(
                          '${snapshot.data['likes']}',
                          '${snapshot.data['dislikes']}',
                          '${snapshot.data['comments']}',
                          context,
                          docRef,
                          'images',
                          url)
                    ],
                  ),
                );
              } else {
                return Container();
              }
            } else {
              return Container();
            }
            break;
          default:
            return Container();
        }
      },
    );
  }

  @override
  void dispose() {
    _image = null;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
