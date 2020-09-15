import 'package:flutter/material.dart';

class EmptyListIllustration extends StatelessWidget {
  final bool isHomeScreen;

  EmptyListIllustration(this.isHomeScreen);

  String _getText(bool isHomeScreen) {
    return isHomeScreen
        ? '''Your reading list is empty.
Tap the + button to add some books.'''
        : '''This list shows all the books you've finished reading.''';
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(50, 5, 50, 30),
            child: Text(_getText(isHomeScreen),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Image.asset('assets/undraw_note_list.png'),
            ),
          ),
        ],
      ),
    );
  }
}
