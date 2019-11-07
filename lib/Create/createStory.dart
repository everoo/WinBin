import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class CreateStory extends StatefulWidget {
  @override
  _CreateStoryState createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  String mainText = "";
  TextEditingController _cont = TextEditingController();
  bool uploadAvailable = false;
  bool _editing = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 522,
      child: Center(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
              child: (_editing)?TextField(
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
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    gapPadding: 5,
                  ),
                ),
                maxLines: 20,
                maxLength: 10000,
                maxLengthEnforced: false,
                onChanged: (text) {
                  mainText = text;
                  if (mainText != '') {
                    setState(() {
                      uploadAvailable = true;
                    });
                  } else {
                    setState(() {
                      uploadAvailable = false;
                    });
                  }
                },
              ):Container(),
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
      ),
    );
  }

  void submit() async {
    if (uploadAvailable) {
      SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
      _cont.clear();
      setState(() {
        uploadAvailable = false;
      });
      int currentTime = Timestamp.now().seconds;
      Firestore.instance
          .collection("stories")
          .document('stories-${currentUser.uid}-$currentTime')
          .setData(
              {"story": mainText, 'likes': 0, 'dislikes': 0, 'comments': 0});
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(Firestore.instance
            .collection('all')
            .document('${Timestamp.now().toDate()}'.substring(0, 10)));
        await transaction.update(freshSnap.reference, {
          '${(freshSnap.data == null) ? 0 : freshSnap.data.length - 1}':
              'stories-${currentUser.uid}-$currentTime'
        });
      });
      await Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(
            Firestore.instance.collection('users').document(currentUser.uid));
        List<dynamic> list = List.from(freshSnap.data['posts']);
        list.add('stories-${currentUser.uid}-$currentTime');
        await transaction.update(
          freshSnap.reference,
          <String, dynamic>{
            'posts': list,
          },
        );
      });
    }
  }
}
