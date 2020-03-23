import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';
import 'package:Archive/MyStuff/MyStyle.dart';
import 'package:Archive/MyStuff/MySubmitBar.dart';

class CreateStory extends StatefulWidget {
  @override
  _CreateStoryState createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  TextEditingController _cont = TextEditingController();
  bool _editing = true;
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.85,
      child: Column(
        children: <Widget>[
          ReadDecoration(
            height: height * 0.64,
            margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: (_editing)
                ? Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextField(
                      style: themeData.textTheme.headline6,
                      controller: _cont,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        counterStyle: themeData.textTheme.headline6,
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
                      maxLines: (height * 0.032).toInt(),
                      maxLength: 10000,
                      maxLengthEnforced: true,
                      onChanged: (d) {
                        data = {'story': _cont.text};
                      },
                    ),
                  )
                : Container(
                    height: height * 0.64,
                    child: ListView(
                      children: <Widget>[
                        StyledText(_cont.text),
                      ],
                    )),
          ),
          SubmitBar([
            [
              () {
                submit(
                    context: context,
                    type: 'stories',
                    data: data,
                    func: () {
                      setState(() {
                        _cont.clear();
                      });
                    },
                    available: _cont.text.replaceAll(' ', '').isNotEmpty);
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
                  _editing = !_editing;
                });
              },
              Icon(
                (_editing) ? Icons.remove_red_eye : Icons.edit,
                size: 20,
                color: themeData.textTheme.headline6.color,
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
                color: themeData.textTheme.headline6.color,
              ),
            ],
          ]),
        ],
      ),
    );
  }
}
