import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';
import 'package:Archive/MyStuff/MySubmitBar.dart';

class CreateStory extends StatefulWidget {
  @override
  _CreateStoryState createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  TextEditingController _cont = TextEditingController();
  FocusNode _focus = FocusNode();
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
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 6, 10, 0),
                child: TextField(
                  focusNode: _focus,
                  style: themeData.textTheme.headline6,
                  controller: _cont,
                  textCapitalization: TextCapitalization.sentences,
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
                  textAlign: TextAlign.center,
                  maxLines: (height * 0.032).toInt(),
                  onChanged: (d) => data = {'story': _cont.text},
                  onTap: () {
                    lightImpact();
                    if (_focus.hasFocus) {
                      _focus.unfocus();
                    } else {
                      _focus.requestFocus();
                    }
                  },
                ),
              )),
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
