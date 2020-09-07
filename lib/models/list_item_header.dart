import 'package:flutter/material.dart';

class ListItemHeader {
  final String headingText;
  final int headingCount;

  ListItemHeader(this.headingText, this.headingCount);

  Widget buildTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 10),
      child: Text(
        '$headingText ($headingCount)',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget buildSubtitle(BuildContext context) => null;
  Widget buildTrailing(BuildContext context) => null;
  Widget buildLeading(BuildContext context) => null;
}
