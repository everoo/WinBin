import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:winbin/Read/ReadMeme.dart';
import 'package:winbin/Read/ReadMusic.dart';
import 'package:winbin/Read/ReadPoll.dart';
import 'package:winbin/Read/ReadStory.dart';
import 'package:winbin/Read/ReadVideo.dart';
import 'package:winbin/main.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final _myListKey = GlobalKey<AnimatedListState>();
  List dataLists = [];
  List dataListsNum = [];
  List<String> documentReferences = [];

  @override
  void initState() {
    super.initState();
    scrollers[1].addListener(listeningFunc);
  }

  void listeningFunc() {
    bgController.jumpTo((scrollers[1].offset / 4) + 150);
  }

  @override
  bool wantKeepAlive = true;
  var rando = new Random();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('all')
                .document('${Timestamp.now().toDate()}'.substring(0, 10))
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (!snapshot.data.exists) {
                    Firestore.instance
                        .collection('all')
                        .document(
                            '${Timestamp.now().toDate()}'.substring(0, 10))
                        .setData({'null': 'null'});
                    return Text('Loading...');
                  } else {
                    snapshot.data.data.remove('null');
                    snapshot.data.data
                        .forEach((numToAddString, valueToAdd) async {
                      int numToAdd = int.parse(numToAddString);
                      if (true) {
                        if (!dataListsNum.contains(numToAdd)) {
                          bool gettingData = true;
                          String collectionKey = valueToAdd.split('-').first;
                          Uint8List imgVidData;
                          //see if we even need to add data
                          if (collectionKey == 'images' ||
                              collectionKey == 'videos') {
                            imgVidData = await FirebaseStorage.instance
                                .ref()
                                .child(valueToAdd)
                                .getData(100 * 1024 * 1024)
                                .then((d) {
                              gettingData = false;
                              return d;
                            });
                          } else {
                            imgVidData = Uint8List(0);
                            gettingData = false;
                          }
                          while (gettingData) {}
                          //this is my sorting function
                          if ((dataListsNum.isEmpty) ||
                              (numToAdd > dataListsNum.last) ||
                              (dataListsNum.length == 1 &&
                                  numToAdd > dataListsNum[0])) {
                            dataListsNum.add(numToAdd);
                            await dataLists.add(imgVidData);
                            documentReferences.add(valueToAdd);
                            _myListKey.currentState.insertItem(
                                documentReferences.length - 1,
                                duration: Duration(seconds: 1));
                          } else {
                            int currentIndex = 0;
                            while (numToAdd > dataListsNum[currentIndex]) {
                              currentIndex += 1;
                            }
                            dataListsNum.insert(currentIndex, numToAdd);
                            await dataLists.insert(currentIndex, imgVidData);
                            documentReferences.insert(currentIndex, valueToAdd);
                            _myListKey.currentState.insertItem(currentIndex,
                                duration: Duration(seconds: 1));
                          }
                        }
                      }
                    });
                    return AnimatedList(
                      padding: EdgeInsets.only(bottom: 8),
                      controller: scrollers[1],
                      initialItemCount: documentReferences.length,
                      key: _myListKey,
                      itemBuilder: (BuildContext context, int index,
                          Animation animation) {
                        return (documentReferences[index].split('-').first == 'images')
                            ? ReadMeme(documentReferences[index], dataLists[index])
                            : (documentReferences[index].split('-').first == 'polls')
                                ? ReadPoll(documentReferences[index])
                                : (documentReferences[index].split('-').first == 'stories')
                                    ? ReadStory(documentReferences[index])
                                    : (documentReferences[index].split('-').first == 'videos')
                                        ? ReadVideo(docRef: documentReferences[index])
                                        : (documentReferences[index].split('-').first == 'songs')
                                            ? ReadMusic(docRef: documentReferences[index])
                                            : Text('none');
                      },
                    );
                  }
              }
            }),
      ],
    );
  }
}
