import 'package:flutter/material.dart';
import 'package:winbin/Globals.dart';

class StyledText extends StatelessWidget {
  final String ogString;
  String changelessString = '';
  List finalStrings = [];

  StyledText({Key key, this.ogString}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double biggestSize = 0;
    // List finalSizes = [];
    // List finalPads = [];
    List split;
    split = ogString.split('/');
    for (String l in split) {
      if (l.contains('|')) {
        var fin = l.split('|');
        finalStrings.add(fin);
      } else {
        finalStrings.add([l]);
      }
    }
    finalStrings.forEach((f) {
      changelessString += f[0];
    });
    //clean up this code later trying to make it so words stay centered in ther line when stylized
    // finalStrings.forEach((s) {
    //   s.forEach((c) {
    //     if (double.tryParse(c) != null) {
    //       double size = double.parse(c);
    //       finalSizes.add(size);
    //       if (size>biggestSize) {
    //         biggestSize = size;
    //       }
    //     } else {
    //       finalSizes.add(14);
    //     }
    //   });
    // });
    // print(biggestSize);
    // print(finalSizes);
    // print(finalStrings);
    // int count = 0;
    // finalSizes.forEach((size) {
    //   print(size);
    //   double pad = biggestSize-size/2;
    //   print(pad);
    //   // finalStrings[count].insert(1, pad);
    //   // count += 1;
    // });
    // print(finalStrings);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 22),
      child: Center(
        child: Wrap(
          children: <Widget>[
            for (List p in finalStrings)
              (p.length == 1)
                  ? Container(
                      child: Text(p[0], style: themeData.textTheme.title),
                      //margin: EdgeInsets.fromLTRB(0, p[1], 0, p[1]),
                    )
                  : Container(
                      child: Text(p[0], style: SStyle(p)),
                      //margin: EdgeInsets.fromLTRB(0, p[1], 0, p[1]),
                    )
          ],
        ),
      ),
    );
  }
}

class SStyle extends TextStyle {
  final List<String> changes;
  SStyle(this.changes);

  @override
  FontWeight get fontWeight {
    if (changes.contains('bold')) {
      return FontWeight.bold;
    } else {
      return FontWeight.normal;
    }
  }

  @override
  FontStyle get fontStyle {
    if (changes.contains('italic')) {
      return FontStyle.italic;
    } else {
      return FontStyle.normal;
    }
  }

  @override
  double get fontSize {
    for (var change in changes) {
      if (double.tryParse(change) != null) {
        return double.parse(change);
      }
    }
    return super.fontSize;
  }

  @override
  Color get color {
    List _colors = ['red', 'blue', 'green', 'yellow', 'purple', 'teal'];
    var colorChange = '';
    for (var change in changes) {
      if (_colors.contains(change)) {
        colorChange = change;
      }
    }
    switch (colorChange) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'teal':
        return Colors.teal;
      default:
        if (darkMode) {
          return Colors.grey[400];
        } else {
          return Colors.black;
        }
    }
  }

  @override
  Color get backgroundColor {
    List _colors = ['hred', 'hblue', 'hgreen', 'hyellow', 'hpurple', 'hteal'];
    var colorChange = '';
    for (var change in changes) {
      if (_colors.contains(change)) {
        colorChange = change;
      }
    }
    switch (colorChange) {
      case 'hred':
        return Colors.red;
      case 'hblue':
        return Colors.blue;
      case 'hgreen':
        return Colors.green;
      case 'hyellow':
        return Colors.yellow;
      case 'hpurple':
        return Colors.purple;
      case 'hteal':
        return Colors.teal;
      default:
        return Colors.transparent;
    }
  }
}
