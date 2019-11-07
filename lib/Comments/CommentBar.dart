import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:winbin/Comments/CommentView.dart';
import 'package:winbin/main.dart';

void like(int way, String type, String reference) async {
  String which = 'likes';
  if (way == -1) {
    which = 'dislikes';
  }
  var docCount = Firestore.instance.collection(type).document(reference);
  var updatingDoc = await docCount.get();
  var doc = docCount.collection('likes').document(currentUser.uid);
  var docCheck = await doc.get();
  if (docCheck.exists) {
    if (docCheck.data['0'] == way) {
      doc.updateData({'0': 0});
      docCount.updateData({which: updatingDoc.data[which] - 1});
    } else if (docCheck.data['0'] == 0) {
      doc.updateData({'0': way});
      if (way == -1) {
        docCount.updateData({'dislikes': updatingDoc.data['dislikes'] + 1});
      } else if (way == 1) {
        docCount.updateData({'likes': updatingDoc.data['likes'] + 1});
      }
    } else {
      doc.updateData({'0': way});
      if (way == -1) {
        docCount.updateData({
          'likes': updatingDoc.data['likes'] - 1,
          'dislikes': updatingDoc.data['dislikes'] + 1
        });
      } else if (way == 1) {
        docCount.updateData({
          'likes': updatingDoc.data['likes'] + 1,
          'dislikes': updatingDoc.data['dislikes'] - 1
        });
      }
    }
  } else {
    docCount.updateData({which: updatingDoc.data[which] + 1});
    doc.setData({'0': way});
  }
}

class CommentBar extends StatelessWidget {
  final String likes;
  final String dislikes;
  final String comments;
  final BuildContext context;
  final String docRef;
  final String type;

  CommentBar(this.likes, this.dislikes, this.comments, this.context,
      this.docRef, this.type);

  @override
  Widget build(BuildContext context) {
    List _necessities = [
      [
        themeData.colorScheme.primary,
        EdgeInsets.fromLTRB(0, 7, 0, 1),
        Column(children: <Widget>[Icon(Icons.thumb_up, size: 20), Text(likes)]),
        () => like(1, type, docRef)
      ],
      [
        themeData.colorScheme.primaryVariant,
        EdgeInsets.fromLTRB(0, 7, 0, 1),
        Column(children: <Widget>[Icon(Icons.comment), Text(comments)]),
        _showComments
      ],
      [
        themeData.colorScheme.secondary,
        EdgeInsets.fromLTRB(0, 7, 0, 1),
        Column(children: <Widget>[Icon(Icons.thumb_down), Text(dislikes)]),
        () => like(-1, type, docRef)
      ],
      [
        themeData.colorScheme.surface,
        EdgeInsets.fromLTRB(0, 0, 2, 2),
        Icon(Icons.share),
        _share
      ],
      [
        themeData.colorScheme.secondaryVariant,
        EdgeInsets.fromLTRB(3, 0, 2, 1),
        Icon(Icons.flag),
        _report
      ],
    ];
    if (true) {
      _necessities = _necessities.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
      child: Column(
        children: <Widget>[
          Container(height: 1, width: 335, color: Colors.grey, margin: EdgeInsets.only(bottom: 8),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for (var nececity in _necessities)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: Container(
                    width: 50,
                    height: 50,
                    child: RaisedButton(
                      color: nececity[0],
                      elevation: 0,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(14.6)),
                      padding: nececity[1],
                      child: nececity[2],
                      onPressed: nececity[3],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComments() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CommentView(docRef, type)));
  }

  void _report() {
    TextEditingController _reportController;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String _reason;
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Please type why you want to report this.',
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: TextFormField(
              maxLength: 50,
              validator: (d) {
                return (d.length < 30)
                    ? 'It needs to be longer than 30 characters.'
                    : null;
              },
              onSaved: (d) {
                _reason = d;
              },
              autofocus: true,
              controller: _reportController,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                final _formState = _formKey.currentState;
                if (_formState.validate()) {
                  _formState.save();
                  Firestore.instance
                      .collection('flagged')
                      .document(docRef)
                      .setData({'who': currentUser.uid, 'why': _reason});
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _share() {
    showModalBottomSheet(
        builder: (BuildContext context) {
          return Row(
            children: <Widget>[
              Container(height: 500,),
              FlatButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: 'aple'));
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.content_copy),
              ),
              Text('data'),
              Text('data'),
              Text('data'),
            ],
          );
        },
        context: context);
  }
}
