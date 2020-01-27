import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winbin/Comments/CommentView.dart';
import 'package:winbin/Globals.dart';

void like(int way, String type, String reference) async {
  String which = 'likes';
  String notwhich = 'dislikes';
  if (way == -1) {
    which = 'dislikes';
    notwhich = 'likes';
  }
  var docCount = Firestore.instance.collection(type).document(reference);
  var updatingDoc = await docCount.get();
  var doc = docCount.collection('likes').document(myID);
  var docCheck = await doc.get();
  if (docCheck.exists) {
    if (docCheck.data['0'] == way) {
      doc.updateData({'0': 0});
      docCount.updateData({which: updatingDoc.data[which] - 1});
    } else if (docCheck.data['0'] == 0) {
      doc.updateData({'0': way});
      docCount.updateData({which: updatingDoc.data[which] + 1});
    } else {
      doc.updateData({'0': way});
      docCount.updateData({
        which: updatingDoc.data[which] + 1,
        notwhich: updatingDoc.data[notwhich] - 1
      });
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
  final String copied;

  CommentBar(this.likes, this.dislikes, this.comments, this.context,
      this.docRef, this.type, this.copied);

  @override
  Widget build(BuildContext context) {
    List _necessities = [
      [
        themeData.colorScheme.secondary,
        EdgeInsets.fromLTRB(0, 7, 0, 1),
        Column(children: <Widget>[
          Icon(
            Icons.thumb_down,
            color: Colors.black,
          ),
          Text(
            dislikes,
            style: TextStyle(color: Colors.black),
          )
        ]),
        () {
          lightImpact();
          like(-1, type, docRef);
        }
      ],
      [
        themeData.colorScheme.primaryVariant,
        EdgeInsets.fromLTRB(0, 7, 0, 1),
        Column(children: <Widget>[
          Icon(
            Icons.comment,
            color: Colors.black,
          ),
          Text(
            comments,
            style: TextStyle(color: Colors.black),
          )
        ]),
        () {
          lightImpact();
          _showComments();
        }
      ],
      [
        themeData.colorScheme.primary,
        EdgeInsets.fromLTRB(0, 7, 0, 1),
        Column(children: <Widget>[
          Icon(
            Icons.thumb_up,
            size: 20,
            color: Colors.black,
          ),
          Text(
            likes,
            style: TextStyle(color: Colors.black),
          )
        ]),
        () {
          lightImpact();
          like(1, type, docRef);
        }
      ],
      [
        themeData.colorScheme.surface,
        EdgeInsets.fromLTRB(0, 0, 2, 2),
        Icon(
          Icons.share,
          color: Colors.black,
        ),
        () {
          lightImpact();
          Clipboard.setData(ClipboardData(text: copied));
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Copied'),
          ));
        }
      ],
      [
        themeData.colorScheme.secondaryVariant,
        EdgeInsets.fromLTRB(3, 0, 2, 1),
        Icon(
          Icons.flag,
          color: Colors.black,
        ),
        () {
          lightImpact();
          _report();
        }
      ],
    ];
    if (!leftHanded) {
      _necessities = _necessities.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        children: <Widget>[
          Container(
            height: 1,
            width: 335,
            color: Colors.grey,
            margin: EdgeInsets.only(bottom: 8),
          ),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)), //14.6
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
    showDialog<Null>(
        context: context,
        builder: (BuildContext cont) {
          return AlertDialog(
            backgroundColor: themeData.backgroundColor,
            title: Text('Do you want to report the post or the user?', textAlign: TextAlign.center,),
            content: Text(
              'You will no longer be able to see this post once you report it. Reporting the user blocks all posts they\'ve made.',
              style: themeData.textTheme.title,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                padding: EdgeInsets.only(right: 22.5, left: 22.5),
                child: Text(
                  'Cancel',
                  style: themeData.textTheme.title,
                ),
                onPressed: () {
                  lightImpact();
                  Navigator.of(cont).pop();
                },
              ),
              FlatButton(
                padding: EdgeInsets.only(right: 25, left: 25),
                child: Text(
                  'User',
                  style: themeData.textTheme.title,
                ),
                onPressed: () {
                  lightImpact();
                  Navigator.of(cont).pop();
                  showReportField('User');
                },
              ),
              FlatButton(
                padding: EdgeInsets.only(right: 28, left: 28),
                child: Text('Post', style: themeData.textTheme.title),
                onPressed: () {
                  lightImpact();
                  Navigator.of(cont).pop();
                  showReportField('Post');
                },
              ),
            ],
          );
        });
  }

  void showReportField(String type) {
    TextEditingController _reportController;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String _reason;
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeData.backgroundColor,
          title: Text(
            'Please type why you want to report this ${type.toLowerCase()}.',
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: TextFormField(
              maxLength: 50,
              validator: (d) {
                return (d.length < 30) ? 'Give a longer reason.' : null;
              },
              onSaved: (d) {
                _reason = d;
              },
              autofocus: true,
              controller: _reportController,
              decoration: InputDecoration(
                counterStyle: themeData.textTheme.title,
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: themeData.colorScheme.secondary)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: new BorderSide(
                        color: themeData.colorScheme.primaryVariant)),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  gapPadding: 5,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: themeData.textTheme.title,
              ),
              onPressed: () {
                lightImpact();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Report $type', style: themeData.textTheme.title),
              onPressed: () {
                lightImpact();
                final _formState = _formKey.currentState;
                if (_formState.validate()) {
                  _formState.save();
                  Firestore.instance
                      .collection('flagged')
                      .document(
                          (type == 'User') ? {docRef.split('-')[2]} : docRef)
                      .setData({'who': myID, 'why': _reason});
                  SharedPreferences.getInstance().then((d) {
                    List<String> foo = d.getStringList('flagged$type\s') ?? [];
                    foo.add((type == 'User') ? docRef.split('-')[2] : docRef);
                    d.setStringList('flagged$type\s', foo);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
