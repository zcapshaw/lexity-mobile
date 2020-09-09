import 'package:flutter/material.dart';

class ListItemHeader extends StatelessWidget {
  final String headingText;
  final int headingCount;

  ListItemHeader(this.headingText, this.headingCount);

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 30, bottom: 10),
      child: Text(
        '$headingText ($headingCount)',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
