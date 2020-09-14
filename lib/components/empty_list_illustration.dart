import 'package:flutter/material.dart';

class EmptyListIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
            child: Text('''Your reading list is empty.
Tap the + button to add some books.''',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(110, 0, 110, 110),
            child: Image.asset('assets/undraw_note_list.png'),
          ),
        ],
      ),
    );
  }
}
