import 'package:Archive/Globals.dart';
import 'package:Archive/Home/HomePage.dart';
import 'package:Archive/Home/ReadMeme.dart';
import 'package:flutter/material.dart';

class ToolBar extends StatelessWidget {
  final HomeTabState tab;
  //this is where I add the -60 to account for the ad space
  final double hei = height * 0.94;
  final List<Shadow> shadows = List<Shadow>.generate(
      5, (index) => Shadow(blurRadius: 1, color: themeData.backgroundColor));

  ToolBar(this.tab);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        for (List _l in [
          [
            EdgeInsets.only(
                top: hei - height * 0.06 - 2,
                left: (leftHanded) ? width * 0.8 : 0),
            tab.searchForDoc,
            Text(
              '${docNum + 1}',
              style: TextStyle(
                  shadows: shadows, color: themeData.textTheme.headline6.color),
            ),
            tab.datas.isNotEmpty
          ],
          [
            EdgeInsets.only(left: (leftHanded) ? 0 : width * 0.8, top: hei),
            tab.filterTags,
            Icon(
              Icons.filter_list,
              color: themeData.textTheme.headline6.color,
            ),
            true
          ],
          [
            EdgeInsets.only(top: hei, left: (leftHanded) ? width * 0.8 : 0),
            (tab.datas.isNotEmpty) ? tab.interact : () {},
            Icon(Icons.share, color: themeData.textTheme.headline6.color),
            tab.datas.isNotEmpty
          ],
          [
            EdgeInsets.only(
                top: hei, left: (leftHanded) ? width * 0.6 : width * 0.2),
            () => like(context, false, tab.datas[docNum].documentID),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  (tab.datas.isNotEmpty)
                      ? '${(tab.datas[docNum].data['likes'] ?? {}).values.where((n) => n == false).length ?? 0}'
                      : '',
                  style: TextStyle(color: themeData.textTheme.headline6.color),
                ),
                Icon(Icons.thumb_down,
                    color: themeData.textTheme.headline6.color),
              ],
            ),
            tab.datas.isNotEmpty
          ],
          [
            EdgeInsets.only(top: hei, left: width * 0.4),
            () => addComment(context, tab.datas[docNum].documentID),
            Icon(Icons.add_comment, color: themeData.textTheme.headline6.color),
            tab.datas.isNotEmpty
          ],
          [
            EdgeInsets.only(
                top: hei, left: (leftHanded) ? width * 0.2 : width * 0.6),
            () => like(context, true, tab.datas[docNum].documentID),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.thumb_up,
                    color: themeData.textTheme.headline6.color),
                Text(
                  (tab.datas.isNotEmpty)
                      ? '${(tab.datas[docNum].data['likes'] ?? {}).values.where((n) => n == true).length ?? 0}'
                      : '',
                  style: TextStyle(color: themeData.textTheme.headline6.color),
                ),
              ],
            ),
            tab.datas.isNotEmpty
          ],
          [
            EdgeInsets.only(
                left: (leftHanded) ? 0 : width * 0.8,
                top: hei - height * 0.06 - 2),
            (tab.datas[docNum].documentID.split('-').last == myID ||
                    authorizedUser)
                ? tab.edit
                : () =>
                    tabController.animateTo((tabController.index == 1) ? 0 : 1),
            Icon(
              (tab.datas[docNum].documentID.split('-').last == myID ||
                      authorizedUser)
                  ? Icons.edit
                  : (leftHanded)?Icons.arrow_back:Icons.arrow_forward,
              color: themeData.textTheme.headline6.color,
            ),
            tab.datas.isNotEmpty
          ]
        ])
          Visibility(
            visible: _l[3],
            child: Container(
              margin: _l[0],
              padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
              height: height * 0.06,
              width: width * 0.2,
              child: RaisedButton(
                elevation: 6,
                color: themeData.scaffoldBackgroundColor,
                onPressed: () {
                  _l[1]();
                  lightImpact();
                },
                child: _l[2],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.06)),
              ),
            ),
          ),
      ],
    );
  }
}
