import 'package:flutter/material.dart';

import '../models/listed_book.dart';
import './reco_tile_trailing.dart';
import './swipe_background.dart';

class ListTileItem extends StatelessWidget {
  ListTileItem(
      {@required this.item,
      @required this.tileIndex,
      @required this.enableSwipeRight,
      @required this.onPressTile,
      @required this.deletePrompt,
      @required this.typeChangeAction,
      @required Key key})
      : super(key: key);

  final ListedBook item;
  final int tileIndex;
  final bool enableSwipeRight;
  final Function onPressTile;
  final Future<bool> Function(DismissDirection, ListedBook) deletePrompt;
  final Function typeChangeAction;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Dismissible(
        key: UniqueKey(),
        confirmDismiss: (direction) {
          if (direction == DismissDirection.endToStart) {
            return deletePrompt(direction, item);
          }
          // instant (no) confirmation for startToEnd
          return Future<bool>.value(true);
        },
        direction: enableSwipeRight
            ? DismissDirection.horizontal
            : DismissDirection.endToStart,
        background: SwipeRightBackground(type: item.type),
        secondaryBackground: SwipeLeftBackground(),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            typeChangeAction(item);
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.grey[600],
                content: const Text('Book deleted from list.')));
          }
        },
        child: ListTile(
          leading: Image.network(item.cover ?? ''),
          title: Text(item.titleWithSubtitle ?? ''),
          subtitle: Text(item.authorsAsString ?? ''),
          trailing: RecoTileTrailing(item.recos),
          onTap: () => onPressTile(context, item, tileIndex),
        ),
      ),
      const Divider(
        height: 0,
      )
    ]);
  }
}
