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
  List<FocusNode> focusList =
      List<FocusNode>.generate(16, (index) => FocusNode());
  ScrollController _scrollController = ScrollController();
  List<TextEditingController> textConList = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  //int maxVotes = 1;
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
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.85,
      child: Stack(
        children: <Widget>[
          Container(
            height: height * 0.75,
            child: ListView(
              padding: EdgeInsets.zero,
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
                        textInputAction: TextInputAction.next,
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
                        maxLength: (numb == 0) ? 128 : 512,
                        maxLengthEnforced: true,
                        controller: textConList[numb],
                        focusNode: focusList[numb],
                        onTap: () {
                          if (focusList[numb].hasFocus) {
                            focusList[numb].unfocus();
                          } else {
                            focusList[numb].requestFocus();
                          }
                        },
                        onSubmitted: (t) {
                          if (list.length <= 15 && numList.length - 1 == numb) {
                            addOption();
                          }
                          focusList[numb + 1].requestFocus();
                        },
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
                      (list.length <= 15) ? addOption : null,
                      Icon(Icons.add,
                          color: themeData.textTheme.headline6.color),
                    ],
                    [
                      (list.length > 3) ? removeOption : null,
                      Icon(Icons.remove,
                          color: themeData.textTheme.headline6.color),
                    ]
                  ],
                  size: Size(width / 2, height / 20),
                  margin:
                      EdgeInsets.fromLTRB(width / 4, 0, width / 4, height / 20),
                ),
                Container(height: height * 0.03)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.69, 0, 0),
            child: SubmitBar([
              [
                () {
                  Map<String, dynamic> data = {
                    'question': textConList[0].text,
                    'votes': [],
                    //'maxVotes': maxVotes
                  };
                  int n = 0;
                  for (String item in list.getRange(1, list.length)) {
                    if (item.replaceAll(' ', '') != '') {
                      data.addAll({
                        'answer$n': [item, 0]
                      });
                      n += 1;
                    }
                  }
                  submit(
                      context: context,
                      type: 'polls',
                      data: data,
                      func: clearData,
                      available: uploadAvailable);
                },
                Icon(Icons.file_upload,
                    color: themeData.textTheme.headline6.color),
              ],
              [
                () {
                  lightImpact();
                  clearData();
                },
                Icon(Icons.clear, color: themeData.textTheme.headline6.color),
              ],
            ], 
            // specialButton: [
            //   () => showDialog<bool>(
            //         context: context,
            //         builder: (con) {
            //           return AlertDialog(
            //             backgroundColor: themeData.secondaryHeaderColor,
            //             title: Text(
            //               'Choose how many times somebody can vote.',
            //               textAlign: TextAlign.center,
            //               style: themeData.textTheme.headline6,
            //             ),
            //             content: TextField(
            //                 autofocus: true,
            //                 keyboardType: TextInputType.number,
            //                 style: themeData.textTheme.headline6,
            //                 textAlign: TextAlign.center,
            //                 onChanged: (t) => setState(() =>
            //                     maxVotes = min(int.tryParse(t), 99) ?? 1)),
            //           );
            //         },
            //       ),
            //   Text(
            //     '$maxVotes',
            //     style: themeData.textTheme.headline6,
            //   )
            // ]
            ),
          ),
        ],
      ),
    );
  }

  addOption() {
    lightImpact();
    setState(() {
      list.add('');
      numList.add(numList.length);
      if (textConList.length < numList.length) {
        textConList.add(TextEditingController());
      }
      _scrollController.jumpTo(_scrollController.offset + 107);
    });
  }

  removeOption() {
    lightImpact();
    setState(() {
      list.removeLast();
      numList.removeLast();
      _scrollController.jumpTo(_scrollController.offset - 107);
    });
  }

  clearData() {
    setState(() {
      //maxVotes = 1;
      for (TextEditingController controller in textConList) controller.clear();
      numList = [0, 1, 2];
      list = ['', '', ''];
    });
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
