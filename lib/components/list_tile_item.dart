import 'package:flutter/material.dart';

import 'swipe_background.dart';
import 'reco_tile_trailing.dart';
import '../models/list_item.dart';

class ListTileItem extends StatelessWidget {
  final ListItem item;
  final bool enableSwipeRight;
  final Function onPressTile;
  final Function deletePrompt;

  ListTileItem(
      {@required this.item,
      @required this.enableSwipeRight,
      @required this.onPressTile,
      @required this.deletePrompt,
      @required Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Dismissible(
        key: UniqueKey(),
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            return Future<bool>.value(true);
          } else if (direction == DismissDirection.endToStart) {
            return deletePrompt(direction, item);
          }
        },
        direction: enableSwipeRight
            ? DismissDirection.horizontal
            : DismissDirection.endToStart,
        background: SwipeRightBackground(type: item.type),
        secondaryBackground: SwipeLeftBackground(),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            //_updateType(item);
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.grey[600],
                content: Text("Book deleted from list.")));
          }
        },
        child: ListTile(
          leading: Image.network(item.bookCover),
          title: Text(item.titleWithSubtitle),
          subtitle: Text(item.bookAuthors[0]),
          trailing: RecoTileTrailing(item.bookRecos),
          onTap: () => onPressTile(item.bookId),
        ),
      ),
      Divider(
        height: 0,
      )
    ]);
  }
}
