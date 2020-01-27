import 'package:flutter/material.dart';
import 'package:winbin/Globals.dart';
import 'package:winbin/MyStuff/MySubmitBar.dart';

class CreatePoll extends StatefulWidget {
  @override
  _CreatePollState createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll> {
  List<String> list = ['', '', ''];
  List<int> numList = [0, 1, 2];
  ScrollController _scrollController = ScrollController();
  List<TextEditingController> textConList = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  bool uploadAvailable = false;
  SubmitBar _bar;
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
    Map<String, dynamic> data = {
      'question': textConList[0].text,
      'likes': 0,
      'dislikes': 0,
      'comments': 0
    };
    int n = 0;
    for (String item in list.getRange(1, list.length)) {
      if (item != '') {
        data.addEntries([
          MapEntry('answer$n', [item, 0])
        ]);
      }
      n += 1;
    }
    return Container(
      height: 560,
      width: 350,
      child: Stack(
        children: <Widget>[
          Container(
            height: 490,
            child: ListView(
              controller: _scrollController,
              children: <Widget>[
                for (var numb in numList)
                  ReadDecoration(
                    margin: EdgeInsets.fromLTRB((numb == 0) ? 16 : 30,
                        (numb == 0) ? 10 : 0, (numb == 0) ? 16 : 30, 8),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                      child: TextField(
                        cursorColor: themeData.cursorColor,
                        style: themeData.textTheme.title,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            counterStyle: themeData.textTheme.title,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: themeData.colorScheme.secondary)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color:
                                        themeData.colorScheme.primaryVariant)),
                            filled: true,
                            fillColor: themeData.backgroundColor,
                            contentPadding: EdgeInsets.all(5),
                            hintText: (numb == 0)
                                ? 'Your Question'
                                : 'Answer ${intToText[numb-1]}',
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
                  ),
                SubmitBar(
                  [
                    [
                      (list.length <= 15)
                          ? () {
                              lightImpact();
                              setState(() {
                                list.add('');
                                numList.add(numList.length);
                                if (textConList.length < numList.length) {
                                  textConList.add(TextEditingController());
                                }
                                _scrollController
                                    .jumpTo(_scrollController.offset + 109);
                              });
                            }
                          : null,
                      Icon(
                        Icons.add,
                        color: themeData.textTheme.title.color,
                      ),
                    ],
                    [
                      (list.length > 3)
                          ? () {
                              lightImpact();
                              setState(() {
                                list.removeLast();
                                numList.removeLast();
                                _scrollController
                                    .jumpTo(_scrollController.offset - 109);
                              });
                            }
                          : null,
                      Icon(
                        Icons.remove,
                        color: themeData.textTheme.title.color,
                      ),
                    ],
                  ], size: Size(177, 40), margin: EdgeInsets.fromLTRB(99, 0, 99, 30),
                )
              ],
            ),
          ),
          Container(
            height: 85,
            margin: EdgeInsets.fromLTRB(0, 470, 0, 0),
            child: _bar = SubmitBar(
              [
                [
                  () {
                    _bar.submit(null, 'polls', data, () {
                      setState(() {
                        for (TextEditingController controller in textConList) {
                          controller.clear();
                        }
                      });
                    }, uploadAvailable);
                  },
                  Icon(
                    Icons.file_upload,
                    color: themeData.textTheme.title.color,
                  ),
                ],
                [
                  () {
                    lightImpact();
                    setState(() {
                      for (TextEditingController controller in textConList) {
                        controller.clear();
                      }
                    });
                  },
                  Icon(
                    Icons.clear,
                    color: themeData.textTheme.title.color,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void checkIfUploadAvailable() {
    var questionAmount = 0;
    for (var text in list) {
      if (text != '') {
        questionAmount += 1;
      }
    }
    if (textConList[0].text != '' && questionAmount > 2) {
      setState(() {
        uploadAvailable = true;
      });
    } else {
      setState(() {
        uploadAvailable = false;
      });
    }
  }
}
