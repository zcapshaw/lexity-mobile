import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'swipe_background.dart';
import 'reorderable_list_w_physics.dart';
import 'reco_tile_trailing.dart';
import 'book_list_bloc.dart';
import 'list_item_header.dart';
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
  // List<ReadingListItem> readingList;
  UserModel user;
  final ScrollController reorderScrollController = ScrollController();

  @override
  initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = Provider.of<UserModel>(context, listen: false);
  }

  // Construct Header text based on list type
  String _getHeaderText(String type, int count) {
    String headerText;
    switch (type) {
      case 'READING':
        {
          headerText = 'Reading ($count)';
        }
        break;
      case 'TO_READ':
        {
          headerText = 'Want to read ($count)';
        }
        break;
      default:
        {
          headerText = '';
        }
        break;
    }
    return headerText;
  }

  void _updateType(readingListItem) async {
    String newType;
    switch (readingListItem.type) {
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
    final jsonItem = jsonEncode({
      'userId': user.id,
      'bookId': readingListItem.bookId,
      'type': newType,
    });
    print(jsonItem);
    final http.Response res = await http.post(
      'https://api.lexity.co/list/add',
      headers: {
        'access-token': '${user.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonItem,
    );
    if (res.statusCode == 200) {
      // Calling setState will rebuild <Future> widget and trigger backend list query
      setState(() {});
      print('successfully update to type $newType');
    } else {
      print(res.statusCode);
      print(res.reasonPhrase);
      print(res.body);
    }
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
                  bookListBloc.deleteBook(
                      book, user.accessToken, user.id, book.bookListId);
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
          initialData: {},
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Container(
              child: RefreshIndicator(
                onRefresh: () => bookListBloc.refreshBackendBookList(
                    user.accessToken, user.id),
                child: CustomReorderableListView(
                  scrollController: reorderScrollController,
                  scrollDirection: Axis.vertical,
                  onReorder: (oldIndex, newIndex) =>
                      bookListBloc.reorderBook(oldIndex, newIndex),
                  header: ListItemHeader('Reading', 3),
                  children: List.generate(
                    snapshot.data.length,
                    (index) {
                      if (snapshot.hasData && snapshot.data[index] != null) {
                        // if (snapshot.data[index] is HeadingItem) {
                        //   return Column(
                        //     key: UniqueKey(),
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: <Widget>[
                        //       ListTile(
                        //         leading:
                        //             snapshot.data[index].buildLeading(context),
                        //         title: snapshot.data[index].buildTitle(context),
                        //         subtitle:
                        //             snapshot.data[index].buildSubtitle(context),
                        //         trailing:
                        //             snapshot.data[index].buildTrailing(context),
                        //       ),
                        //       Divider(
                        //         height: 0,
                        //       ),
                        //     ],
                        //   );
                        // }
                        return Column(
                            key: ValueKey(snapshot.data[index].bookId),
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Dismissible(
                                key: UniqueKey(),
                                confirmDismiss: (direction) {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    return Future<bool>.value(true);
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    return _promptUser(
                                        direction, snapshot.data[index]);
                                  }
                                },
                                direction: widget.enableSwipeRight
                                    ? DismissDirection.horizontal
                                    : DismissDirection.endToStart,
                                background: SwipeRightBackground(
                                    type: snapshot.data[index].type),
                                secondaryBackground: SwipeLeftBackground(),
                                onDismissed: (direction) {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    _updateType(snapshot.data[index]);
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        backgroundColor: Colors.grey[600],
                                        content:
                                            Text("Book deleted from list.")));
                                  }
                                },
                                child: ListTile(
                                  leading: Image.network(
                                      snapshot.data[index].bookCover),
                                  title: Text(snapshot.data[index].bookTitle),
                                  subtitle:
                                      Text(snapshot.data[index].bookAuthors[0]),
                                  trailing: RecoTileTrailing(
                                      snapshot.data[index].bookRecos),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookDetailScreen(
                                          bookId: snapshot.data[index].bookId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Divider(
                                height: 0,
                              )
                            ]);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }
}
