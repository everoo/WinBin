import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';
import 'package:Archive/MyStuff/MySubmitBar.dart';

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
  Map<String, dynamic> data = {};
  bool uploadAvailable = false;
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
  void initState() {
    _scrollController.addListener(() { 
      bgController.jumpTo(_scrollController.offset/2+500);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height*0.85,
      child: Stack(
        children: <Widget>[
          Container(
            height: height*0.75,
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
                        style: themeData.textTheme.headline6,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            counterStyle: themeData.textTheme.headline6,
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
                                : 'Answer ${intToText[numb - 1]}',
                            hintStyle: themeData.textTheme.headline6),
                        scrollPadding: EdgeInsets.all(10),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        maxLength: 128,
                        controller: textConList[numb],
                        onChanged: (text) {
                          list[numb] = text;
                          checkIfUploadAvailable();
                          data = {'question': textConList[0].text, 'votes': []};
                          int n = 0;
                          for (String item in list.getRange(1, list.length)) {
                            if (item.replaceAll(' ', '') != '') {
                              data.addAll({
                                'answer$n': [item, 0]
                              });
                              n += 1;
                            }
                          }
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
                                    .jumpTo(_scrollController.offset + 107);
                              });
                            }
                          : null,
                      Icon(Icons.add,
                          color: themeData.textTheme.headline6.color),
                    ],
                    [
                      (list.length > 3)
                          ? () {
                              lightImpact();
                              setState(() {
                                list.removeLast();
                                numList.removeLast();
                                _scrollController
                                    .jumpTo(_scrollController.offset - 107);
                              });
                            }
                          : null,
                      Icon(Icons.remove,
                          color: themeData.textTheme.headline6.color),
                    ]
                  ],
                  size: Size(width / 2, height / 20),
                  margin:
                      EdgeInsets.fromLTRB(width / 4, 0, width / 4, height / 20),
                ),
                Container(height: height*0.03)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.69, 0, 5),
            child: SubmitBar(
              [
                [
                  () {
                    submit(
                        context: context,
                        type: 'polls',
                        data: data,
                        func: () {
                          setState(() {
                            for (TextEditingController controller
                                in textConList) {
                              controller.clear();
                            }
                          });
                        },
                        available: uploadAvailable);
                  },
                  Icon(
                    Icons.file_upload,
                    color: themeData.textTheme.headline6.color,
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
                    color: themeData.textTheme.headline6.color,
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
      if (text.replaceAll(' ', '') != '') {
        questionAmount += 1;
      }
    }
    if (textConList[0].text.replaceAll(' ', '') != '' && questionAmount > 2) {
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
