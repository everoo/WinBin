import 'dart:io';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Comments/CommentCard.dart';
import 'package:winbin/Globals.dart';

class CommentView extends StatefulWidget {
  final String docRef;
  final String type;
  CommentView(this.docRef, this.type);
  @override
  _CommentViewState createState() => _CommentViewState(docRef, type);
}

class _CommentViewState extends State<CommentView> {
  String documentRef;
  String type;
  _CommentViewState(this.documentRef, this.type);
  TextEditingController _cunt = TextEditingController();
  FocusNode _focus = FocusNode();
  TextField field;
  int lastN;
  Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    //Admob.initialize(getAppId());
    _stream = Firestore.instance
        .collection(type)
        .document(documentRef)
        .collection('comments')
        .snapshots();
    super.initState();
  }

  String getAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2732851918745448~9909103202';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2732851918745448~7563454543';
    }
    return null;
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2732851918745448/5606896116';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2732851918745448/4937291206';
    }
    return null;
  }

  @override
  void deactivate() {
    _focus.unfocus();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData.secondaryHeaderColor,
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: themeData.colorScheme.surface,
      ),
      body: ListView(
        primary: false,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: TextField(
              onChanged: (c) {
                setState(() {});
              },
              textCapitalization: TextCapitalization.sentences,
              focusNode: _focus,
              controller: _cunt,
              style: themeData.textTheme.title,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: themeData.colorScheme.secondary)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: themeData.colorScheme.primaryVariant)),
                  contentPadding: EdgeInsets.all(8)),
            ),
          ),
          Container(
            height: 550,
            child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorMessage(snapshot.error);
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    List<CommentCard> _commentCard = [];
                    lastN = snapshot.data.documents.length;
                    for (DocumentSnapshot l in snapshot.data.documents) {
                      print(l.data['n']);
                      _commentCard.insert(
                          l.data['n'],
                          CommentCard(
                              name: l.data['name'],
                              time: '${l.data['time'].toDate()}',
                              message: l.data['comment'],
                              likes: l.data['likes'],
                              dislikes: l.data['dislikes'],
                              documentRef: documentRef,
                              n: l.data['n']));
                    }
                    return ListView(
                      children: <Widget>[
                        for (CommentCard com in _commentCard) com,
                        Container(
                          height: 100,
                        ),
                      ],
                    );
                  default:
                    return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeData.colorScheme.primary,
        child: Icon(
          (_cunt.text.isEmpty) ? Icons.add : Icons.send,
          color: themeData.textTheme.title.color,
        ),
        onPressed: (_cunt.text.isEmpty)
            ? () {
                _focus.requestFocus();
                lightImpact();
              }
            : () {
                lightImpact();
                Firestore.instance.runTransaction((transaction) async {
                  DocumentReference docref =
                      Firestore.instance.collection(type).document(documentRef);
                  DocumentSnapshot freshSnap = await transaction.get(docref);
                  transaction.update(freshSnap.reference,
                      {'comments': freshSnap.data['comments'] + 1});
                });
                Firestore.instance
                    .collection(type)
                    .document(documentRef)
                    .collection('comments')
                    .document('comment$lastN')
                    .setData({
                  'comment': _cunt.text,
                  'likes': 0,
                  'dislikes': 0,
                  'n': lastN,
                  'name': myID,
                  'time': Timestamp.now()
                }).then((t) {
                  _cunt.text = '';
                });
              },
      ),
    );
  }
}
