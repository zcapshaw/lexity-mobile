import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'reorderable_list_w_physics.dart';
import 'book_list_bloc.dart';
import 'list_tile_header.dart';
import 'list_tile_item.dart';
import '../screens/book_detail_screen.dart';
import '../models/list_item.dart';
import '../models/user.dart';

class ReadingList extends StatefulWidget {
  final List<String> types;
  final bool enableSwipeRight;
  final bool enableHeaders;

  ReadingList(
      {@required this.types,
      this.enableSwipeRight = true,
      this.enableHeaders = true});

  @override
  _ReadingListState createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {
  UserModel user;
  final ScrollController reorderScrollController = ScrollController();

  @override
  initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = Provider.of<UserModel>(context, listen: false);
  }

  void _updateType(ListItem book, int oldIndex) async {
    String newType;
    switch (book.bookType) {
      case 'READING':
        {
          newType = 'READ';
        }
        break;
      case 'TO_READ':
        {
          newType = 'READING';
        }
        break;
      default:
        {
          newType = 'TO_READ';
        }
        break;
    }
    bookListBloc.changeBookType(book, user.currentUser, oldIndex, newType);
  }

  Future<bool> _promptUser(DismissDirection direction, ListItem book) async {
    return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: Text("Are you sure you want to delete ${book.title}?"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Delete"),
                onPressed: () {
                  // Dismiss the dialog and also dismiss the swiped item
                  bookListBloc.deleteBook(book, user.currentUser);
                  Navigator.of(context).pop(true);
                },
              ),
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  // Dismiss the dialog but don't dismiss the swiped item
                  return Navigator.of(context).pop(false);
                },
              )
            ],
          ),
        ) ??
        false; // In case the user dismisses the dialog by clicking away from it
  }

  void _onPressTile(String bookId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailScreen(
          bookId: bookId,
        ),
      ),
    );
  }

  _navigateToBookDetails(BuildContext context, bookId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailScreen(
          bookId: bookId,
        ),
      ),
    );
    setState(() {});
    if (result == true) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("Successfully updated list."),
          backgroundColor: Colors.grey[600],
          duration: Duration(seconds: 1),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StreamBuilder(
        stream: bookListBloc.listBooks, // Stream getter
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Container(
            child: RefreshIndicator(
              onRefresh: () => bookListBloc.refreshBackendBookList(
                  user.accessToken, user.id),
              child: CustomReorderableListView(
                scrollController: reorderScrollController,
                scrollDirection: Axis.vertical,
                onReorder: (oldIndex, newIndex) => bookListBloc.reorderBook(
                    user.currentUser, oldIndex, newIndex),
                children: List.generate(snapshot.data.length, (index) {
                  if (snapshot.hasData && snapshot.data[index] != null) {
                    if (snapshot.data[index] is ListItemHeader &&
                        widget.enableHeaders &&
                        widget.types
                            .contains(snapshot.data[index].headerType)) {
                      return ListTileHeader(
                        type: snapshot.data[index].bookType,
                        key: UniqueKey(),
                      );
                    } else if (snapshot.data[index] is ListItem &&
                        snapshot.data[index] is! ListItemHeader &&
                        widget.types.contains(snapshot.data[index].bookType)) {
                      return ListTileItem(
                        item: snapshot.data[index],
                        tileIndex: index,
                        enableSwipeRight: widget.enableSwipeRight,
                        onPressTile: _onPressTile,
                        deletePrompt: _promptUser,
                        typeChangeAction: _updateType,
                        key: ValueKey(snapshot.data[index].bookId),
                      );
                    } else {
                      return Container(key: UniqueKey(), height: 0, width: 0);
                    }
                  }
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
