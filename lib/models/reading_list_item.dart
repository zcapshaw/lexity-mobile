import 'package:flutter/material.dart';
import 'package:lexity_mobile/components/reco_tile_trailing.dart';

/// The base class for the different types of items the list can contain.
abstract class ReadingListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);

  // The trailing widget to show in a list item.
  Widget buildTrailing(BuildContext context);

  // The trailing widget to show in a list item.
  Widget buildLeading(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ReadingListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 10),
      child: Text(
        heading,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget buildSubtitle(BuildContext context) => null;
  Widget buildTrailing(BuildContext context) => null;
  Widget buildLeading(BuildContext context) => null;
}

/// A ListItem that contains book info
class BookItem implements ReadingListItem {
  final String title;
  final String subtitle;
  final String cover;
  final String listId;
  final String bookId;
  final String type;
  final List<dynamic> recos;

  BookItem(this.title, this.subtitle, this.cover, this.listId, this.bookId,
      this.type, this.recos);

  String get bookTitle {
    return this.title;
  }

  Widget buildLeading(BuildContext context) => Image.network(cover);
  Widget buildTitle(BuildContext context) => Text(title);
  Widget buildSubtitle(BuildContext context) => Text(subtitle);
  Widget buildTrailing(BuildContext context) => RecoTileTrailing(recos);
}
