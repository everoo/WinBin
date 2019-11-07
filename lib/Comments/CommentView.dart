import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:winbin/main.dart';

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
    _stream = Firestore.instance
        .collection(type)
        .document(documentRef)
        .collection('comments')
        .snapshots();
    super.initState();
  }

  @override
  void deactivate() {
    _focus.unfocus();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: themeData.colorScheme.surface,
      ),
      body: ListView(
        primary: false,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: TextField(
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
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  default:
                    lastN = snapshot.data.documents.length;
                    return ListView(
                      children: <Widget>[
                        for (var l in snapshot.data.documents)
                          (!l.data.isEmpty)
                              ? Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            (l.data['name'] != null)
                                                ? '${l.data['name']}'
                                                : 'Anonymous',
                                            style: themeData.textTheme.title,
                                          ),
                                          Text(
                                            (l.data['time'] != null)
                                                ? ('${l.data['time'].toDate()}'
                                                        .substring(5, 16)
                                                        .startsWith('0'))
                                                    ? '${l.data['time'].toDate()}'
                                                        .substring(5, 16)
                                                        .substring(1)
                                                    : '${l.data['time'].toDate()}'
                                                        .substring(5, 16)
                                                : 'timeless',
                                            style: themeData.textTheme.title,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          '${l.data['comment']}',
                                          textAlign: TextAlign.center,
                                          style: themeData.textTheme.title,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 150),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              width: 40,
                                              child: (l.data['name'] != null)
                                                  ? FlatButton(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.reply,
                                                            color: themeData
                                                                .textTheme
                                                                .title
                                                                .color,
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        _cunt.text =
                                                            '@${l.data['name']}';
                                                      },
                                                    )
                                                  : null,
                                            ),
                                            Container(
                                              width: 40,
                                              child: (l.data['name'] != null && l.data['name'] != currentUsersName)
                                                  ? FlatButton(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.edit,
                                                            color: themeData
                                                                .textTheme
                                                                .title
                                                                .color,
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        _cunt.text =
                                                            '@${l.data['name']}';
                                                      },
                                                    )
                                                  : null,
                                            ),
                                            Container(
                                              width: 60,
                                              child: FlatButton(
                                                child: Column(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.thumb_up,
                                                      color: themeData.textTheme
                                                          .title.color,
                                                    ),
                                                    Text(
                                                      '${l.data['likes']}',
                                                      style: themeData
                                                          .textTheme.title,
                                                    )
                                                  ],
                                                ),
                                                onPressed: () {
                                                  Firestore.instance
                                                      .runTransaction(
                                                          (transaction) async {
                                                    DocumentSnapshot freshSnap =
                                                        await transaction.get(
                                                      Firestore.instance
                                                          .collection(type)
                                                          .document(documentRef)
                                                          .collection(
                                                              'comments')
                                                          .document(
                                                              'comment${l.data['n']}'),
                                                    );
                                                    await transaction.update(
                                                        freshSnap.reference, {
                                                      'likes':
                                                          freshSnap['likes'] +
                                                              1,
                                                    });
                                                  });
                                                },
                                              ),
                                            ),
                                            Container(
                                              width: 60,
                                              child: FlatButton(
                                                child: Column(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.thumb_down,
                                                      color: themeData.textTheme
                                                          .title.color,
                                                    ),
                                                    Text(
                                                      '${l.data['dislikes']}',
                                                      style: themeData
                                                          .textTheme.title,
                                                    )
                                                  ],
                                                ),
                                                onPressed: () {
                                                  Firestore.instance
                                                      .runTransaction(
                                                          (transaction) async {
                                                    DocumentSnapshot freshSnap =
                                                        await transaction.get(
                                                      Firestore.instance
                                                          .collection(type)
                                                          .document(documentRef)
                                                          .collection(
                                                              'comments')
                                                          .document(
                                                              'comment${l.data['n']}'),
                                                    );
                                                    await transaction.update(
                                                        freshSnap.reference, {
                                                      'dislikes': freshSnap[
                                                              'dislikes'] +
                                                          1,
                                                    });
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                        Container(
                          height: 70,
                        )
                      ],
                    );
                }
              },
            ),
          ),
        ],
      ),
      //floating action button that sends data
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeData.colorScheme.primary,
        child: Icon(
          (_cunt.text.isEmpty) ? Icons.add : Icons.send,
          color: themeData.textTheme.title.color,
        ),
        onPressed: (_cunt.text.isEmpty)
            ? _focus.requestFocus
            : () {
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
                  'name': currentUsersName,
                  'time': Timestamp.now()
                }).then((t) {
                  _cunt.text = '';
                });
              },
      ),
    );
  }
}
