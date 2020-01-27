import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';////
import 'package:winbin/Globals.dart';
import 'package:winbin/main.dart';


class CustomSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomSwitch();
  }
}

class _CustomSwitch extends State<CustomSwitch> {
  double left = (themeMode == ThemeMode.dark) ? 0 : 198;
  double right = (themeMode == ThemeMode.dark) ? 198 : 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 70,
        child: GestureDetector(
          onHorizontalDragUpdate: (d) {
            left = min(max(d.localPosition.dx - 50, 0), 198);
            right = max(198 - left, 0);
            if (left < 102 && left > 98) {
              lightImpact();
            }
            setState(() {});
          },
          onHorizontalDragEnd: (d) {
            if (left > 99) {
              left = 198;
              right = 0;
              themeMode = ThemeMode.light;
              themeData = lightThemeData;
              setState(() {});
              if (darkMode == true) {
                darkMode = false;
                home.setState();
                SharedPreferences.getInstance().then((d) {
                  d.setBool('darkMode', darkMode);
                });
              }
            } else {
              left = 0;
              right = 198;
              themeMode = ThemeMode.dark;
              themeData = darkThemeData;
              setState(() {});
              if (darkMode == false) {
                darkMode = true;
                home.setState();
                SharedPreferences.getInstance().then((d) {
                  d.setBool('darkMode', darkMode);
                });
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset.fromDirection(1, 3),
                      color: Color(0x55000000),
                      blurRadius: 2,
                      spreadRadius: 2)
                ],
                color: themeData.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(35)),
            //color: themeData.scaffoldBackgroundColor,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    color: themeData.secondaryHeaderColor,
                    width: 225,
                    height: 10,
                  ),
                ),
                AnimatedContainer(
                  margin: EdgeInsets.fromLTRB(left+4, 4, right+4, 0),
                  duration: Duration(milliseconds: 50),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: Offset.fromDirection(1, 3),
                              color: Color(0x55000000),
                              blurRadius: 2,
                              spreadRadius: 2)
                        ],
                        color: themeData.colorScheme.primary,
                        borderRadius: BorderRadius.circular(30)),
                    height: 60,
                    width: 225,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
