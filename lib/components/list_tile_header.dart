import 'package:flutter/material.dart';

class ListTileHeader extends StatelessWidget {
  final String headingText;
  final int headingCount;

  ListTileHeader(this.headingText, this.headingCount, Key key)
      : super(key: key);

  Widget build(BuildContext context) {
    return ListTile(
      title: BuildTitle(headingText, headingCount),
      subtitle: null,
      trailing: null,
      leading: null,
    );
  }
}

class BuildTitle extends StatelessWidget {
  final String headingText;
  final int headingCount;

  BuildTitle(this.headingText, this.headingCount);

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
