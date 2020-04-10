import 'package:Archive/Home/ToolBar.dart';
import 'package:Archive/MyStuff/LoadingIcon.dart';
import 'package:Archive/MyStuff/TagList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';
import 'package:Archive/MyStuff/Drawers.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'ReadMeme.dart';

class HomeTab extends StatefulWidget {
  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<DocumentSnapshot> datas = [];
  Offset memeOffset = Offset.zero;
  double memeAngle = 0;
  List<String> filters = aFilters;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: homeDrawerKey,
      drawer: (leftHanded) ? null : HomeDrawer(),
      endDrawer: (leftHanded) ? HomeDrawer() : null,
      backgroundColor: Colors.transparent,
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('$currentDay'.substring(0, 10))
              .snapshots(),
          builder: (c, s) {
            switch (s.connectionState) {
              case ConnectionState.active:
                if (s.hasError ||
                    !s.hasData ||
                    (s.data.documents.length ?? 0) == 0) {
                  return Center(
                    child: Container(
                      height: width * 0.8,
                      width: width * 0.8,
                      child: RaisedButton(
                        elevation: 15,
                        color: themeData.backgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35)),
                        onPressed: () =>
                            tabController.animateTo((leftHanded) ? 0 : 1),
                        child: Icon(
                          Icons.add,
                          size: width * 0.6,
                          color: themeData.textTheme.headline6.color,
                        ),
                      ),
                    ),
                  );
                } else {
                  datas = s.data.documents;
                  if (filtering) {
                    datas.removeWhere((e) => !e.data['sfw']);
                  }
                  for (var p in flaggedPosts) {
                    datas.removeWhere((e) => e.documentID == p);
                  }
                  for (var p in flaggedUsers) {
                    datas.removeWhere((e) => e.documentID.split('-')[2] == p);
                  }
                  if (filters.isNotEmpty) {
                    for (String f in filters) {
                      if (f == 'Likes') {
                        datas.removeWhere((e) {
                          return (e.data['likes'] ?? {})
                                  .values
                                  .where((n) => n == true)
                                  .length <
                              numFilters[0];
                        });
                      } else if (f == 'Dislikes') {
                        datas.removeWhere((e) {
                          return (e.data['likes'] ?? {})
                                  .values
                                  .where((n) => n == false)
                                  .length <
                              numFilters[1];
                        });
                      } else if (f == 'Comments') {
                        datas.removeWhere((e) {
                          return (e.data ?? {})
                                  .keys
                                  .where((n) => n.length == 25)
                                  .length <
                              numFilters[2];
                        });
                      } else {
                        datas.removeWhere(
                            (e) => !((e.data['tags'] ?? []).contains(f)));
                      }
                    }
                  }
                  if (docNum >= datas.length) docNum = datas.length - 1;
                  if (docNum < 0) docNum = 0;
                  refreshMemes();
                  return Stack(
                    children: <Widget>[
                      (datas.isNotEmpty)
                          ? ReadMeme(
                              datas[docNum].documentID,
                              datas[docNum].data,
                              medias[datas[docNum].documentID],
                              this)
                          : Container(),
                      ToolBar(this),
                      (showingIndicator)?DragIndicator():Container(),
                    ],
                  );
                }
                break;
              default:
                return Container();
            }
          }),
    );
  }

  edit() {
    showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: themeData.backgroundColor,
        title: Text('Edit Your Post', textAlign: TextAlign.center),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (String v in ['Delete', 'Edit Tags'])
              RaisedButton(
                color: themeData.secondaryHeaderColor,
                onPressed: () {
                  lightImpact();
                  Navigator.of(context).pop();
                  if (v == 'Delete') {
                    if (datas[docNum].documentID.contains('videos') ||
                        datas[docNum].documentID.contains('images')) {
                      FirebaseStorage.instance
                          .ref()
                          .child('$currentDay'.substring(0, 4))
                          .child('$currentDay'.substring(5, 7))
                          .child('$currentDay'.substring(0, 10))
                          .child(datas[docNum].documentID)
                          .delete();
                    }
                    Firestore.instance
                        .collection('$currentDay'.substring(0, 10))
                        .document(datas[docNum].documentID)
                        .delete();
                    setState(() {
                      if (docNum > 0) {
                        docNum -= 1;
                      }
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (c) {
                        List<String> t = [];
                        datas[docNum].data['tags'].forEach((l) => t.add(l));
                        return Dialog(
                          backgroundColor: themeData.backgroundColor,
                          child: Container(
                              height: height * 0.3,
                              child:
                                  TagList(t, (List<String> activeTags, List _) {
                                Firestore.instance
                                    .collection('$currentDay'.substring(0, 10))
                                    .document(datas[docNum].documentID)
                                    .updateData({'tags': activeTags});
                              }, () {}, 'Tag Your Post')),
                        );
                      },
                    );
                  }
                },
                child: Text(v, style: themeData.textTheme.headline6),
              )
          ],
        ),
      ),
    );
  }

  interact() {
    String _copyable = datas[docNum].data['url'] ?? '';
    if (datas[docNum].documentID.split('-')[1] == 'stories') {
      String _s = '';
      datas[docNum]
          .data['story']
          .split(' ')
          .forEach((n) => _s += n.split('\\').first);
      _copyable = _s;
    }
    if (datas[docNum].documentID.split('-')[1] == 'polls') {
      String _q = datas[docNum].data['question'];
      String _a = '';
      for (var l in List<int>.generate(16, (x) => x)) {
        if (datas[docNum].data['answer$l'] != null)
          _a += '\n${datas[docNum].data['answer$l']}';
      }
      _copyable = '$_q$_a';
    }
    showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: themeData.backgroundColor,
        title: Text('Share or Report', textAlign: TextAlign.center),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (String v in ['Copy Data', 'Report'])
              RaisedButton(
                color: themeData.secondaryHeaderColor,
                onPressed: () {
                  lightImpact();
                  Navigator.of(context).pop();
                  if (v == 'Copy Data') {
                    Clipboard.setData(ClipboardData(text: _copyable));
                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content: Container(
                        height: height * 0.03 + 60,
                        child: Text(
                          _copyable,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ));
                  } else {
                    _report(context);
                  }
                },
                child: Text(v, style: themeData.textTheme.headline6),
              )
          ],
        ),
      ),
    );
  }

  filterTags() {
    showDialog(
      context: context,
      builder: (c) {
        return Dialog(
          backgroundColor: themeData.backgroundColor,
          child: Container(
            height: height * 0.3,
            child: TagList(
              filters,
              (List<String> activeTags, List<int> _tmpNums) {
                numFilters = _tmpNums;
                docNum = 0;
                setState(() => filters = activeTags);
                SharedPreferences.getInstance()
                    .then((v) => v.setStringList('filters', filters));
              },
              () => setState(() {
                filters = [];
                SharedPreferences.getInstance()
                    .then((v) => v.setStringList('filters', filters));
              }),
              'Sort by Tags',
            ),
          ),
        );
      },
    );
  }

  searchForDoc() {
    showDialog(
        context: context,
        builder: (c) {
          return Dialog(
            backgroundColor: themeData.backgroundColor,
            child: Container(
              height: height * 0.3,
              padding: EdgeInsets.fromLTRB(
                  width * 0.08, height * 0.0, width * 0.08, height * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Go to post number:',
                    style: themeData.textTheme.headline6,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    style: themeData.textTheme.headline6,
                    textInputAction: TextInputAction.go,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (t) {
                      if (t.contains('.')) {
                        String s = t.replaceFirst('.', '');
                        if (int.tryParse(s) != null) {
                          setState(() {
                            goToDoc(int.parse(s) - 1);
                          });
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    onSubmitted: (s) {
                      if (int.tryParse(s) != null) {
                        setState(() {
                          goToDoc(int.parse(s) - 1);
                        });
                      }
                      Navigator.of(context).pop();
                    },
                    autofocus: true,
                  ),
                  Text(
                    '(max for ${'$currentDay'.substring(0, 10)} is ${datas.length})',
                    style: themeData.textTheme.headline6,
                  ),
                  Text(
                    '(press . to search)',
                    style: themeData.textTheme.headline6,
                  )
                ],
              ),
            ),
          );
        });
  }

  goToDoc(int which) {
    setState(() {
      if (which >= datas.length) {
        docNum = (datas.length ?? 1) - 1;
      } else if (which < 0) {
        docNum = 0;
      } else {
        docNum = which;
      }
    });
    SharedPreferences.getInstance()
        .then((value) => value.setInt('$currentDay'.substring(0, 10), docNum));
  }

  refreshMemes() {
    [-2, -1, 0, 1, 2].forEach((e) => addMeme(docNum + e));
    [-3, 3].forEach((e) => removeMeme(docNum + e));
  }

  addMeme(int at) {
    if (at < datas.length && at >= 0) {
      if (datas[at].documentID.split('-')[1] == 'images') {
        Image _im = Image.network(
          datas[at].data['url'],
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return LoadingIcon(loadingProgress.cumulativeBytesLoaded,
                loadingProgress.expectedTotalBytes);
          },
        );
        precacheImage(_im.image, context).catchError((e) {
          print(e);
        });
        medias.putIfAbsent(datas[at].documentID, () => _im);
      } else if (datas[at].documentID.split('-')[1] == 'videos') {
        medias.putIfAbsent(
            datas[at].documentID,
            () => VideoPlayerController.network(datas[at].data['url'])
              ..initialize()
              ..setLooping(looping));
      } else {
        medias.addAll({datas[at].documentID: ''});
      }
    }
  }

  removeMeme(int at) async {
    if (at < datas.length && at >= 0) {
      if (datas[at].documentID.split('-')[1] == 'images') {
        medias.remove(datas[at].documentID).image.evict();
      } else if (datas[at].documentID.split('-')[1] == 'videos') {
        medias.remove(datas[at].documentID).dispose();
      } else {
        medias.remove(datas[at].documentID);
      }
    }
  }

  _report(BuildContext context) {
    showDialog<Null>(
        context: context,
        builder: (BuildContext cont) {
          return AlertDialog(
            backgroundColor: themeData.backgroundColor,
            title: Text('Do you want to report the post or the user?',
                textAlign: TextAlign.center),
            content: Text(
              'You will no longer be able to see this post once you report it. Reporting the user blocks all posts they\'ve made.',
              style: themeData.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              for (String _n in ['Cancel', 'User', 'Post'])
                FlatButton(
                  padding: EdgeInsets.only(right: 24, left: 24),
                  child: Text(_n, style: themeData.textTheme.headline6),
                  onPressed: () {
                    lightImpact();
                    Navigator.of(cont).pop();
                    if (_n != 'Cancel') showReportField(_n, context);
                  },
                ),
            ],
          );
        });
  }

  showReportField(String type, BuildContext context) {
    TextEditingController _reportController;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String _reason;
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeData.backgroundColor,
          title: Text(
            'Please type why you want to report this ${type.toLowerCase()}.',
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: TextFormField(
              style: themeData.textTheme.headline6,
              maxLength: 50,
              validator: (d) {
                return (d.length < 30) ? 'Give a longer reason.' : null;
              },
              onSaved: (d) {
                _reason = d;
              },
              autofocus: true,
              controller: _reportController,
              decoration: InputDecoration(
                counterStyle: themeData.textTheme.headline6,
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: themeData.colorScheme.secondary)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: new BorderSide(
                        color: themeData.colorScheme.primaryVariant)),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  gapPadding: 5,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: themeData.textTheme.headline6,
              ),
              onPressed: () {
                lightImpact();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Report $type', style: themeData.textTheme.headline6),
              onPressed: () {
                lightImpact();
                final _formState = _formKey.currentState;
                if (_formState.validate()) {
                  _formState.save();
                  Firestore.instance
                      .collection('0000flagged')
                      .document((type == 'User')
                          ? datas[docNum].documentID.split('-')[2]
                          : datas[docNum].documentID)
                      .setData({'who': myID, 'why': _reason});
                  SharedPreferences.getInstance().then((d) {
                    List<String> foo = d.getStringList('flagged$type\s') ?? [];
                    foo.add((type == 'User')
                        ? datas[docNum].documentID.split('-')[2]
                        : datas[docNum].documentID);
                    d.setStringList('flagged$type\s', foo);
                  });
                  if (type == 'User') {
                    flaggedUsers.add(datas[docNum].documentID.split('-')[2]);
                  } else {
                    flaggedPosts.add(datas[docNum].documentID);
                  }
                  if (docNum > 0) docNum -= 1;
                  Navigator.of(context).pop();
                  homeTab = HomeTab();
                  home.setState();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    medias.forEach((key, value) {
      if (key.contains('videos')) {
        value.pause();
      } else if (key.contains('images')) {
        value.image.evict();
      }
    });
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
