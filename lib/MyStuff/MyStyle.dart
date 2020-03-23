import 'package:flutter/material.dart';
import 'package:Archive/Globals.dart';

class StyledText extends StatelessWidget {
  final String ogString;

  StyledText(this.ogString);

  @override
  Widget build(BuildContext context) {
    List<String> split = ogString.split('/');
    List finalStrings = [];
    split.forEach((x) => finalStrings.add(x.split('-')));
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          for (List p in finalStrings)
            SelectableText(
              p[0],
              style: SStyle(p),
              textAlign: TextAlign.center,
              toolbarOptions: ToolbarOptions(),
            )
        ],
      ),
    );
  }
}

class SStyle extends TextStyle {
  final List<String> changes;
  SStyle(this.changes);

  @override
  FontWeight get fontWeight {
    if (changes.contains('bold')) return FontWeight.bold;
    return FontWeight.normal;
  }

  @override
  FontStyle get fontStyle {
    if (changes.contains('italic')) return FontStyle.italic;
    return FontStyle.normal;
  }

  @override
  double get fontSize {
    for (var change in changes) {
      if (double.tryParse(change) != null) {
        if (double.parse(change) > 400) {
          return 400;
        } else if (double.parse(change) < 0) {
          return super.fontSize;
        } else {
          return double.parse(change);
        }
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
