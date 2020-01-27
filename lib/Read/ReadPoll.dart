import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Comments/CommentBar.dart';
import 'package:winbin/Globals.dart';

class ReadPoll extends StatefulWidget {
  final String docRef;
  final Stream<DocumentSnapshot> stream;

  ReadPoll(this.docRef, this.stream);
  @override
  _ReadPollState createState() => _ReadPollState(docRef, stream);
}

class _ReadPollState extends State<ReadPoll> {
  final Stream<DocumentSnapshot> stream;
  bool answered = false;
  List tt = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  int whichAnswer = 0;
  int totalVotes = 0;

  String documentRef;
  List answers = [];

  _ReadPollState(this.documentRef, this.stream);

  void checkForAnswered() async {
    var longer = await Firestore.instance
        .collection('polls')
        .document(documentRef)
        .collection('votes')
        .document(myID)
        .get();
    if (mounted) {
      if (longer.exists) {
        if (!answered) {
          setState(() {
            answered = true;
          });
        }
      } else {
        if (answered) {
          setState(() {
            answered = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    checkForAnswered();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReadDecoration(
      height: 500,
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('polls')
            .document(documentRef)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorMessage(snapshot.error);
          }
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              answers = [];
              totalVotes = 0;
              for (int l in tt)
                if (snapshot.data['answer$l'] != null) {
                  answers.add(snapshot.data["answer$l"]);
                  totalVotes += snapshot.data['answer$l'][1];
                }
              List<Widget> children = <Widget>[
                for (int l in tt)
                  (l < answers.length)
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(
                              12,
                              (answers.length <= 4) ? 18 / (answers.length) : 8,
                              12,
                              0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: 400,
                                height: (answers.length <= 4)
                                    ? 375 / answers.length
                                    : 75,
                                child: RaisedButton(
                                  disabledColor: themeData.secondaryHeaderColor,
                                  color: themeData.scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  onPressed: (answered)
                                      ? null
                                      : () {
                                          if (!answered) {
                                            answered = true;
                                            lightImpact();
                                            Firestore.instance.runTransaction(
                                                (transaction) async {
                                              DocumentSnapshot freshSnap =
                                                  await transaction.get(
                                                      Firestore.instance
                                                          .collection('polls')
                                                          .document(
                                                              documentRef));
                                              await transaction
                                                  .update(freshSnap.reference, {
                                                'answer$l': [
                                                  freshSnap.data['answer$l'][0],
                                                  freshSnap.data['answer$l']
                                                          [1] +
                                                      1
                                                ],
                                              });
                                              await Firestore.instance
                                                  .collection('polls')
                                                  .document(documentRef)
                                                  .collection('votes')
                                                  .document(myID)
                                                  .setData({'0': true});
                                            });
                                          }
                                        },
                                ),
                              ),
                              IgnorePointer(
                                child: AnimatedContainer(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(style: BorderStyle.none),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      color: themeData.colorScheme.error),
                                  width: (answered)
                                      ? 335 * (answers[l][1] / totalVotes)
                                      : 0,
                                  height: (answers.length <= 4)
                                      ? 375 / answers.length
                                      : 75,
                                  duration: Duration(milliseconds: 600),
                                ),
                              ),
                              IgnorePointer(
                                child: Column(
                                  children: <Widget>[
                                    AnimatedContainer(
                                      height: (answered)
                                          ? max(375 / answers.length / 2, 37.5)
                                          : 375 / answers.length,
                                      child: Center(
                                          child: Text(
                                        answers[l][0],
                                        style: themeData.textTheme.title,
                                      )),
                                      duration: Duration(milliseconds: 600),
                                    ),
                                    AnimatedContainer(
                                      height: (answered)
                                          ? max(375 / answers.length / 2, 37.5)
                                          : 0,
                                      duration: Duration(milliseconds: 600),
                                      child: Center(
                                          child: Text(
                                        '${answers[l][1]}/$totalVotes',
                                        style: themeData.textTheme.title,
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
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Text(
                      snapshot.data['question'],
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: themeData.textTheme.title.color,
                          fontSize: 20),
                    ),
                  ),
                  (answers.length <= 4)
                      ? Container(
                          child: Column(children: children),
                          margin: EdgeInsets.only(bottom: 8),
                        )
                      : Column(
                          children: <Widget>[
                            Container(
                              height: 1,
                              width: 335,
                              color: Colors.grey,
                            ),
                            Container(
                                child: ListView(
                                  children: children,
                                  primary: false,
                                  shrinkWrap: true,
                                ),
                                height: 398),
                          ],
                        ),
                  CommentBar(
                      '${snapshot.data['likes']}',
                      '${snapshot.data['dislikes']}',
                      '${snapshot.data['comments']}',
                      context,
                      documentRef,
                      'polls',
                      snapshot.data['question'])
                ],
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}
