import 'package:flutter/material.dart';
import 'package:winbin/Globals.dart';
import 'package:winbin/MyStuff/MyStyle.dart';
import 'package:winbin/MyStuff/MySubmitBar.dart';

class CreateStory extends StatefulWidget {
  @override
  _CreateStoryState createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  TextEditingController _cont = TextEditingController();
  bool _editing = true;
  SubmitBar _bar;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560,
      child: Column(
        children: <Widget>[
          Container(
            height: 453,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
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
            child: (_editing)
                ? Container(
                    child: TextField(
                      style: TextStyle(
                        color: themeData.textTheme.title.color,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 3.0),
                            blurRadius: 3.0,
                          ),
                        ],
                      ),
                      controller: _cont,
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
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 5,
                        ),
                      ),
                      maxLines: 22,
                      maxLength: 10000,
                      maxLengthEnforced: true,
                    ),
                  )
                : Container(
                    height: 450,
                    child: ListView(
                      children: <Widget>[
                        StyledText(
                          ogString: _cont.text,
                        ),
                      ],
                    )),
          ),
          _bar = SubmitBar([
            [
              (){_bar.submit(null, 'stories', {
                'story': _cont.text,
                'likes': 0,
                'comments': 0,
                'dislikes': 0,
              }, () {
                setState(() {
                  _cont.clear();
                });
              }, _cont.text.isNotEmpty);},
              Icon(
                Icons.file_upload,
                color: themeData.textTheme.title.color,
              ),
            ],
            [
              () {
                lightImpact();
                setState(() {
                  _editing = !_editing;
                });
              },
              Icon(
                (_editing) ? Icons.remove_red_eye : Icons.edit,
                size: 20,
                color: themeData.textTheme.title.color,
              ),
            ],
            [
              () {
                lightImpact();
                setState(() {
                  _cont.clear();
                });
              },
              Icon(
                Icons.clear,
                color: themeData.textTheme.title.color,
              ),
            ],
          ]),
        ],
      ),
    );
  }
}
