import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';

class ReadPoll extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentRef;

  ReadPoll(this.documentRef, this.data);

  @override
  Widget build(BuildContext context) {
    List answers = [];
    int totalVotes = 0;
    bool voted = (data['votes'] ?? []).contains(myID);
   // Map<String, int> myVotes = {};
    for (int l in List<int>.generate(16, (s) => s)) {
      if (data['answer$l'] != null) {
        answers.add(data["answer$l"]);
        totalVotes += data['answer$l'][1];
      }
    }

    vote(int l) async {
      lightImpact();
      Firestore.instance.runTransaction(
        (transaction) async {
          DocumentSnapshot freshSnap = await transaction.get(Firestore.instance
              .collection('$currentDay'.substring(0, 10))
              .document(documentRef));
          if (freshSnap.exists) {
            List updatedVotes = freshSnap.data['votes'] ?? [];
            if (!updatedVotes.contains(myID)) {
              updatedVotes.add(myID);
              await transaction.update(
                freshSnap.reference,
                {
                  'answer$l': [
                    freshSnap.data['answer$l'][0],
                    freshSnap.data['answer$l'][1] + 1
                  ],
                  'votes': updatedVotes
                },
              );
            }
          }
        },
      );
    }

    List<Widget> children = <Widget>[
      for (int l in List<int>.generate(16, (s) => s))
        (l < answers.length)
            ? Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.02,
                    0,
                    width * 0.02,
                    (answers.length <= 4)
                        ? height * 0.02 / (answers.length)
                        : 8),
                child: RaisedButton(
                  padding: EdgeInsets.zero,
                  disabledColor: themeData.secondaryHeaderColor,
                  color: themeData.scaffoldBackgroundColor,
                  child: Stack(
                    children: <Widget>[
                      // Text(
                      //     '${myVotes[answers[l][0]] ?? 0}/${data['maxVotes']}'),
                      AnimatedContainer(
                        decoration: BoxDecoration(
                            border: Border.all(style: BorderStyle.none),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: themeData.colorScheme.error),
                        width:
                            (voted) ? width * (answers[l][1] / totalVotes) : 0,
                        height: (answers.length <= 4)
                            ? height * 0.43 / answers.length
                            : height * 0.1,
                        duration: Duration(milliseconds: 600),
                      ),
                      Column(
                        children: <Widget>[
                          for (int i in [0, 1])
                            AnimatedContainer(
                              height: (voted)
                                  ? max(height * 0.43 / answers.length / 2,
                                      height * 0.05)
                                  : (i == 0)
                                      ? height * 0.43 / answers.length
                                      : 0,
                              child: Center(
                                  child: Text(
                                '${answers[l][i]}${(i == 1) ? '/$totalVotes' : ''}',
                                style: themeData.textTheme.headline6,
                                textAlign: TextAlign.center,
                              )),
                              duration: Duration(milliseconds: 600),
                            ),
                        ],
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  onPressed: (voted)
                      ? null
                      : () {
                          // if (myVotes[answers[l][0]] == null) {
                          //   myVotes[answers[l][0]] = 1;
                          // } else {
                          //   myVotes[answers[l][0]] += 1;
                          // }
                          // print(myVotes);
                          vote(l);
                        },
                ),
              )
            : Container(),
    ];

    return ReadDecoration(
      height: height * 0.55,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            height: height * 0.1 - 1,
            margin: EdgeInsets.fromLTRB(width * 0.02, 0, width * 0.02, 0),
            child: ListView(
              padding: EdgeInsets.only(top: height * 0.01),
              children: <Widget>[
                Text(
                  data['question'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: themeData.textTheme.headline6.color,
                      fontSize: 20),
                )
              ],
            ),
          ),
          (answers.length <= 4)
              ? Container(child: Column(children: children))
              : Column(
                  children: <Widget>[
                    Container(
                      height: 1,
                      width: width * 0.92,
                      color: Colors.grey,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                      child: Container(
                          child: ListView(
                            children: children,
                            padding: EdgeInsets.only(top: 8),
                          ),
                          height: height * 0.445),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
