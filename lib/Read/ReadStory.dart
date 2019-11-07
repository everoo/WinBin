import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Comments/CommentBar.dart';
import 'package:winbin/main.dart';

class ReadStory extends StatefulWidget {
  final String docRef;
  ReadStory(this.docRef);
  @override
  _ReadStoryState createState() => _ReadStoryState(docRef);
}

class _ReadStoryState extends State<ReadStory> {
  final String docRef;
  _ReadStoryState(this.docRef);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Container(
        height: 256,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: Offset.fromDirection(1, 3),
              color: Color(0x55000000),
              blurRadius: 2,
              spreadRadius: 2)
        ], color: themeData.backgroundColor, borderRadius: BorderRadius.circular(15)),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('stories')
              .document(docRef)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                List finalStrings = [];
                List split;
                String workableString = snapshot.data['story'];
                split = workableString.split('/');
                for (String l in split) {
                  if (l.contains('|')) {
                    var fin = l.split('|');
                    finalStrings.add(fin);
                  } else {
                    finalStrings.add([l]);
                  }
                }
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 22),
                      child: Container(
                        height: 150,
                        child: Center(
                          child: (snapshot.data != null)
                              ? Wrap(
                                  children: <Widget>[
                                    for (List p in finalStrings)
                                      (p.length == 1)
                                          ? Text(
                                              p[0],
                                              style: TextStyle(color: (darkMode)?Colors.grey[300]:Colors.black),
                                            )
                                          : Text(p[0], style: SStyle(p))
                                  ],
                                )
                              : Container(),
                        ),
                      ),
                    ),
                    CommentBar(
                        '${snapshot.data['likes']}',
                        '${snapshot.data['dislikes']}',
                        '${snapshot.data['comments']}',
                        context,
                        docRef,
                        'stories')
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}

class SStyle extends TextStyle {
  final List<String> changes;
  SStyle(this.changes);

  @override
  FontWeight get fontWeight {
    if (changes.contains('bold')) {
      return FontWeight.bold;
    } else {
      return FontWeight.normal;
    }
  }

  @override
  FontStyle get fontStyle {
    if (changes.contains('italic')) {
      return FontStyle.italic;
    } else {
      return FontStyle.normal;
    }
  }

  @override
  double get fontSize {
    for (var change in changes) {
      if (double.tryParse(change) != null) {
        return double.parse(change);
      }
    }
    return super.fontSize;
  }

  @override
  Color get color {
    List _colors = ['red', 'blue', 'green', 'yellow', 'purple', 'teal'];
    var colorChange = '';
    for (var change in changes) {
      if (_colors.contains(change)) {
        colorChange = change;
      }
    }
    switch (colorChange) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'teal':
        return Colors.teal;
      default:
        if (darkMode) {
          return Colors.white;
        } else {
          return Colors.black;
        }
    }
  }

  @override
  Color get backgroundColor {
    List _colors = ['hred', 'hblue', 'hgreen', 'hyellow', 'hpurple', 'hteal'];
    var colorChange = '';
    for (var change in changes) {
      if (_colors.contains(change)) {
        colorChange = change;
      }
    }
    switch (colorChange) {
      case 'hred':
        return Colors.red;
      case 'hblue':
        return Colors.blue;
      case 'hgreen':
        return Colors.green;
      case 'hyellow':
        return Colors.yellow;
      case 'hpurple':
        return Colors.purple;
      case 'hteal':
        return Colors.teal;
      default:
        return Colors.transparent;
    }
  }
}
