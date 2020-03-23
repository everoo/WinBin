import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Globals.dart';

class TagList extends StatefulWidget {
  final List<String> currentTags;
  final clearAll;
  final apply;
  final String title;
  TagList(this.currentTags, this.clearAll, this.apply, this.title);
  @override
  _TagListState createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  var _stream =
      Firestore.instance.collection('0000tags').document('all').snapshots();

  List<int> _tmpNumFilters = numFilters;
  List<TextEditingController> _texts =
      List.generate(3, (x) => TextEditingController(text: '${numFilters[x]}'));

  @override
  Widget build(BuildContext context) {
    List<String> activeTags = widget.currentTags;
    return Container(
      child: StreamBuilder<DocumentSnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snap) {
          switch (snap.connectionState) {
            case ConnectionState.active:
              return ListView(
                children: <Widget>[
                  Container(height: height * 0.03),
                  (widget.title == 'Sort by Tags')
                      ? Center(
                          child: Text('Filter by Stats',
                              style: themeData.textTheme.headline6))
                      : Container(),
                  for (List t in [
                    ['Likes', 0],
                    ['Dislikes', 1],
                    ['Comments', 2]
                  ])
                    (widget.title == 'Sort by Tags')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('More Than ',
                                  style: themeData.textTheme.headline6),
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                child: TextField(
                                  controller: _texts[t[1]],
                                  keyboardType: TextInputType.number,
                                  style: themeData.textTheme.headline6,
                                  textAlign: TextAlign.center,
                                  onChanged: (s) {
                                    _tmpNumFilters[t[1]] = int.tryParse(s) ?? 0;
                                  },
                                ),
                                width: width * 0.15,
                              ),
                              RaisedButton(
                                color: (widget.currentTags.contains(t[0]))
                                    ? themeData.colorScheme.background
                                    : themeData.secondaryHeaderColor,
                                onPressed: () {
                                  lightImpact();
                                  setState(() {
                                    if (activeTags.contains(t[0])) {
                                      activeTags.remove(t[0]);
                                    } else {
                                      activeTags.add(t[0]);
                                    }
                                  });
                                },
                                child: Container(
                                  width: width * 0.2,
                                  child: Text(
                                    t[0],
                                    style: themeData.textTheme.headline6,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  Center(
                      child: Text(
                          (widget.title == 'Sort by Tags')
                              ? 'Or ${widget.title}'
                              : widget.title,
                          style: themeData.textTheme.headline6)),
                  for (String t in snap.data.data['tags'])
                    Center(
                        child: RaisedButton(
                      color: (widget.currentTags.contains(t))
                          ? themeData.colorScheme.background
                          : themeData.secondaryHeaderColor,
                      onPressed: () {
                        lightImpact();
                        setState(() {
                          if (activeTags.contains(t)) {
                            activeTags.remove(t);
                          } else {
                            activeTags.add(t);
                          }
                        });
                      },
                      child: Text(t, style: themeData.textTheme.headline6),
                    )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for (String t in ['Clear All', 'Apply'])
                        Center(
                            child: RaisedButton(
                                color: themeData.secondaryHeaderColor,
                                onPressed: () {
                                  lightImpact();
                                  if (t == 'Clear All') {
                                    setState(() => activeTags.clear());
                                    widget.apply();
                                  } else {
                                    widget.clearAll(activeTags, _tmpNumFilters);
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text(t,
                                    style: themeData.textTheme.headline6)))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'It sorts for all not any so when filtering with multiple tags it returns posts with only those tags.',
                      style: themeData.textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(height: height * 0.03)
                ],
              );
              break;
            default:
              return Container();
          }
        },
      ),
    );
  }
}
