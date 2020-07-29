import 'package:flutter/material.dart';

class ListTileHeaderText extends StatelessWidget {
  const ListTileHeaderText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.left,
      ),
    );
  }
}
