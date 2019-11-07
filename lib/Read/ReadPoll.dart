import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Comments/CommentBar.dart';
import 'package:winbin/main.dart';

class ReadPoll extends StatefulWidget {
  final String docRef;

  ReadPoll(this.docRef);
  @override
  _ReadPollState createState() => _ReadPollState(docRef);
}

class _ReadPollState extends State<ReadPoll> {
  bool answered = false;
  List tt = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  int whichAnswer = 0;
  int totalVotes = 0;

  String documentRef;
  List answers = [];

  _ReadPollState(this.documentRef);

  void checkForAnswered() async {
    var longer = await Firestore.instance
        .collection('polls')
        .document(documentRef)
        .collection('votes')
        .document(currentUser.uid)
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Container(
        height: 500,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset.fromDirection(1, 3),
                  color: Color(0x55000000),
                  blurRadius: 2,
                  spreadRadius: 2)
            ],
            color: themeData.backgroundColor,
            borderRadius: BorderRadius.circular(25)),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('polls')
              .document(documentRef)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
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
                                (answers.length <= 4)
                                    ? 18 / (answers.length)
                                    : 8,
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
                                    disabledColor:
                                        themeData.secondaryHeaderColor,
                                    color: themeData.scaffoldBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    onPressed: (answered)
                                        ? null
                                        : () {
                                            if (!answered) {
                                              answered = true;
                                              Firestore.instance.runTransaction(
                                                  (transaction) async {
                                                DocumentSnapshot freshSnap =
                                                    await transaction.get(
                                                        Firestore.instance
                                                            .collection('polls')
                                                            .document(
                                                                documentRef));
                                                await transaction.update(
                                                    freshSnap.reference, {
                                                  'answer$l': [
                                                    freshSnap.data['answer$l']
                                                        [0],
                                                    freshSnap['answer$l'][1] + 1
                                                  ],
                                                });
                                                await Firestore.instance
                                                    .collection('polls')
                                                    .document(documentRef)
                                                    .collection('votes')
                                                    .document(currentUser.uid)
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        color: themeData.colorScheme.error),
                                    width: (answered)
                                        ? 400 * (answers[l][1] / totalVotes)
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
                                            ? 375 / answers.length / 2
                                            : 375 / answers.length,
                                        child: Center(
                                            child: Text(
                                          answers[l][0],
                                          style: TextStyle(
                                              color: (darkMode)
                                                  ? Colors.grey[400]
                                                  : Colors.black),
                                        )),
                                        duration: Duration(milliseconds: 600),
                                      ),
                                      AnimatedContainer(
                                        height: (answered)
                                            ? 375 / answers.length / 2
                                            : 0,
                                        duration: Duration(milliseconds: 600),
                                        child: Center(
                                            child: Text(
                                          '${answers[l][1]}/$totalVotes',
                                          style: TextStyle(
                                              color: (darkMode)
                                                  ? Colors.grey[400]
                                                  : Colors.black),
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
                            color: (darkMode) ? Colors.grey[400] : Colors.black,
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
                        'polls')
                  ],
                );
                break;
              default:
                return Container();
                break;
            }
          },
        ),
      ),
    );
  }
}
