import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:winbin/main.dart';

class CreatePoll extends StatefulWidget {
  @override
  _CreatePollState createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll> {
  String question = "";
  List list = ["", ""];
  List numList = [0, 1];
  List textConList = [TextEditingController(), TextEditingController()];
  bool uploadAvailable = false;
  TextEditingController questionController = TextEditingController();
  var intToText = [
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 522,
      child: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset.fromDirection(1, 3),
                      color: Color(0x55000000),
                      blurRadius: 2,
                      spreadRadius: 2)
                ],
                color: themeData.backgroundColor,
                borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: TextField(
              cursorColor: themeData.cursorColor,
              style: TextStyle(color: themeData.textTheme.title.color),
              textCapitalization: TextCapitalization.sentences,
              controller: questionController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: themeData.colorScheme.secondary)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: themeData.colorScheme.primaryVariant)),
                  filled: true,
                  counterStyle: themeData.textTheme.title,
                  fillColor: themeData.backgroundColor,
                  contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  hintText: "Your Question",
                  hintStyle: themeData.textTheme.title),
              textAlign: TextAlign.center,
              maxLines: 3,
              maxLength: 256,
              onChanged: (text) {
                question = text;
                checkIfUploadAvailable();
              },
            ),
          ),
          for (var numb in numList)
            Container(
              margin: EdgeInsets.fromLTRB(24, 00, 24, 10),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset.fromDirection(1, 3),
                        color: Color(0x55000000),
                        blurRadius: 2,
                        spreadRadius: 2)
                  ],
                  color: themeData.backgroundColor,
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
              child: TextField(
                cursorColor: themeData.cursorColor,
                style: TextStyle(color: themeData.textTheme.title.color),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    counterStyle: themeData.textTheme.title,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: themeData.colorScheme.secondary)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: themeData.colorScheme.primaryVariant)),
                    filled: true,
                    fillColor: themeData.backgroundColor,
                    contentPadding: EdgeInsets.all(5),
                    hintText: "Answer ${intToText[numb]}",
                    hintStyle: themeData.textTheme.title),
                scrollPadding: EdgeInsets.all(10),
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                maxLines: 3,
                maxLength: 128,
                controller: textConList[numb],
                onChanged: (text) {
                  list[numb] = text;
                  checkIfUploadAvailable();
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(99, 10, 99, 0),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset.fromDirection(1, 3),
                        color: Color(0x55000000),
                        blurRadius: 2,
                        spreadRadius: 2)
                  ],
                  color: themeData.backgroundColor,
                  borderRadius: BorderRadius.circular(20)),
              width: 177,
              height: 40,
              child: Row(
                children: <Widget>[
                  FlatButton(
                    child: Icon(
                      Icons.add,
                      color: themeData.textTheme.title.color,
                    ),
                    onPressed: (list.length <= 16)
                        ? () {
                            SystemChannels.platform
                                .invokeMethod<void>('HapticFeedback.vibrate');
                            setState(() {
                              list.add("");
                              numList.add(numList.length);
                              if (textConList.length < numList.length) {
                                textConList.add(TextEditingController());
                              }
                            });
                          }
                        : null,
                  ),
                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.grey,
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.remove,
                      color: themeData.textTheme.title.color,
                    ),
                    onPressed: (list.length > 2)
                        ? () {
                            SystemChannels.platform
                                .invokeMethod<void>('HapticFeedback.vibrate');
                            setState(() {
                              list.removeLast();
                              numList.removeLast();
                              //textConList.removeLast();
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(140, 10, 140, 40),
            child: RaisedButton(
              color: (uploadAvailable)
                  ? themeData.colorScheme.primaryVariant
                  : Colors.grey,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: submit,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                child: Icon(
                  Icons.file_upload,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkIfUploadAvailable() {
    var questionAmount = 0;
    for (var text in list) {
      if (text != "") {
        questionAmount += 1;
      }
    }
    if (question != "" && questionAmount >= 2) {
      setState(() {
        uploadAvailable = true;
      });
    } else {
      setState(() {
        uploadAvailable = false;
      });
    }
  }

  void submit() async {
    if (uploadAvailable) {
      SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
      setState(() {
        uploadAvailable = false;
      });
      int currentTime = Timestamp.now().seconds;
      Map<String, dynamic> data = {
        "question": question,
        "likes": 0,
        "dislikes": 0,
        "comments": 0
      };
      int n = 0;
      for (var item in list) {
        data.addEntries([
          MapEntry("answer$n", [item, 0])
        ]);
        n += 1;
      }
      await Firestore.instance
          .collection("polls")
          .document('polls-${currentUser.uid}-$currentTime')
          .setData(data);
      await Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(Firestore.instance
            .collection('all')
            .document('${Timestamp.now().toDate()}'.substring(0, 10)));
        await transaction.update(freshSnap.reference, {
          '${(freshSnap.data == null) ? 0 : freshSnap.data.length - 1}':
              'polls-${currentUser.uid}-$currentTime'
        });
      });
      await Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(
            Firestore.instance.collection('users').document(currentUser.uid));
        List<dynamic> list = List.from(freshSnap.data['posts']);
              list.add('polls-${currentUser.uid}-$currentTime');
              await transaction.update(
                freshSnap.reference,
                <String, dynamic>{
                  'posts': list,
                },
              );
      });
      questionController.clear();
      for (TextEditingController controller in textConList) {
        controller.clear();
      }
    }
  }
}
