import 'package:flutter/material.dart';

import 'swipe_background.dart';
import 'reco_tile_trailing.dart';
import '../models/list_item.dart';

class ListTileItem extends StatelessWidget {
  final ListItem item;
  final int tileIndex;
  final bool enableSwipeRight;
  final Function onPressTile;
  final Function deletePrompt;
  final Function typeChangeAction;

  ListTileItem(
      {@required this.item,
      @required this.tileIndex,
      @required this.enableSwipeRight,
      @required this.onPressTile,
      @required this.deletePrompt,
      @required this.typeChangeAction,
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
            typeChangeAction(item, tileIndex);
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.grey[600],
                content: Text("Book deleted from list.")));
          }
        },
        child: ListTile(
          leading: Hero(
            tag: '${item.bookCover}__heroTag',
            child: Image.network(item.bookCover ?? ''),
          ),
          title: Text(item.titleWithSubtitle ?? ''),
          subtitle: Text(item.bookAuthors[0] ?? ''),
          trailing: RecoTileTrailing(item.bookRecos),
          onTap: () => onPressTile(context, item, tileIndex),
        ),
      ),
      Divider(
        height: 0,
      )
    ]);
  }
}
