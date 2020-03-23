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
    for (int l in List<int>.generate(16, (s) => s)) {
      if (data['answer$l'] != null) {
        answers.add(data["answer$l"]);
        totalVotes += data['answer$l'][1];
      }
    }
    List<Widget> children = <Widget>[
      for (int l in List<int>.generate(16, (s) => s))
        (l < answers.length)
            ? Padding(
                padding: EdgeInsets.fromLTRB(
                    12,
                    (answers.length <= 4)
                        ? height * 0.02 / (answers.length)
                        : 8,
                    12,
                    0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: width * 0.96,
                      height: (answers.length <= 4)
                          ? height * 0.42 / answers.length
                          : height * 0.12,
                      child: RaisedButton(
                          disabledColor: themeData.secondaryHeaderColor,
                          color: themeData.scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          onPressed: (voted)
                              ? null
                              : () async {
                                  answers[l][1] += 1;
                                  lightImpact();
                                  Firestore.instance
                                      .runTransaction((transaction) async {
                                    DocumentSnapshot freshSnap =
                                        await transaction.get(Firestore.instance
                                            .collection(
                                                '${currentDay.toDate()}'.substring(0, 10))
                                            .document(documentRef));
                                    if (freshSnap.exists) {
                                      List updatedVotes =
                                          freshSnap.data['votes'] ?? [];
                                      if (!updatedVotes.contains(myID)) {
                                        updatedVotes.add(myID);
                                        await transaction
                                            .update(freshSnap.reference, {
                                          'answer$l': [
                                            freshSnap.data['answer$l'][0],
                                            freshSnap.data['answer$l'][1] + 1
                                          ],
                                          'votes': updatedVotes
                                        });
                                      }
                                    }
                                  });
                                }),
                    ),
                    IgnorePointer(
                      child: AnimatedContainer(
                        decoration: BoxDecoration(
                            border: Border.all(style: BorderStyle.none),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: themeData.colorScheme.error),
                        width: (voted)
                            ? width * 0.96 * (answers[l][1] / totalVotes)
                            : 0,
                        height: (answers.length <= 4)
                            ? height * 0.42 / answers.length
                            : height * 0.12,
                        duration: Duration(milliseconds: 600),
                      ),
                    ),
                    IgnorePointer(
                      child: Column(
                        children: <Widget>[
                          AnimatedContainer(
                            height: (voted)
                                ? max(height * 0.42 / answers.length / 2,
                                    height * 0.06)
                                : height * 0.42 / answers.length,
                            child: Center(
                                child: Text(
                              answers[l][0] ?? '',
                              style: themeData.textTheme.headline6,
                              textAlign: TextAlign.center,
                            )),
                            duration: Duration(milliseconds: 600),
                          ),
                          AnimatedContainer(
                            height: (voted)
                                ? max(height * 0.42 / answers.length / 2,
                                    height * 0.06)
                                : 0,
                            duration: Duration(milliseconds: 600),
                            child: Center(
                                child: Text(
                              '${answers[l][1] ?? ''}/$totalVotes',
                              style: themeData.textTheme.headline6,
                            )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
    ];
    children.add(Container(height: 8));
    return ReadDecoration(
      height: height * 0.55,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            height: height * 0.08 - 1,
            child: ListView(children: <Widget>[
              Text(data['question'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: themeData.textTheme.headline6.color,
                      fontSize: 20))
            ]),
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
                          child: ListView(children: children),
                          height: height * 0.47),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
