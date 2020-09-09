import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'swipe_background.dart';
import '../screens/book_detail_screen.dart';
import '../models/reading_list_item.dart';
import '../models/user.dart';
import 'book_list_bloc.dart';

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
  List<ReadingListItem> readingList;
  UserModel user;

  @override
  initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = Provider.of<UserModel>(context, listen: false);
  }

  //Construct a List of ListItems from the API response
  Future<List<ReadingListItem>> _getReadingList() async {
    final http.Response data = await http
        .get('https://api.lexity.co/list/summary/?userId=${user.id}', headers: {
      'access-token': '${user.accessToken}',
    });
    if (data.statusCode == 200) {
      //Construct a 'readingList' array with a HeadingItem and BookItems
      readingList = [];
      var json = jsonDecode(data.body);

      // Cycle through json by type, adding applicable headers
      for (String type in widget.types) {
        if (json[type] != null) {
          int bookCount = json[type].length;
          bookListBloc.addListCountItem(type, bookCount);
          if (widget.enableHeaders) {
            readingList.add(HeadingItem(_getHeaderText(type, bookCount)));
          }
          for (var b in json[type]) {
            String title = b['title'];
            if (b['subtitle'] != null) title = '$title: ${b['subtitle']}';
            BookItem book = BookItem(title, b['authors'][0], b['cover'],
                b['listId'], b['bookId'], b['type'], b['recos']);
            readingList.add(book);
          }
        }
      }
    } else {
      print(data.statusCode);
      print(data.reasonPhrase);
    }

    return readingList;
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
      'notes': [{}], // Temp while updating backend - should not be required
      'labels': [], // Temp while updating backend - should not be required
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

  Future<void> _deleteBook(listId) async {
    final http.Response res = await http.delete(
        'https://api.lexity.co/list/delete/?userId=${user.id}&listId=$listId',
        headers: {
          'access-token': '${user.accessToken}',
        });
    if (res.statusCode == 200) {
      print('successfully deleted book');
    } else {
      print(res.statusCode);
      print(res.reasonPhrase);
    }
  }

  Future<bool> _promptUser(DismissDirection direction, book) async {
    return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: Text("Are you sure you want to delete ${book.title}?"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Delete"),
                onPressed: () {
                  // Dismiss the dialog and also dismiss the swiped item
                  _deleteBook(book.listId);
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
    return Container(
      child: FutureBuilder(
        future: _getReadingList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Expanded(
              child: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          return Flexible(
            child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data[index] is HeadingItem) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: snapshot.data[index].buildLeading(context),
                          title: snapshot.data[index].buildTitle(context),
                          subtitle: snapshot.data[index].buildSubtitle(context),
                          trailing: snapshot.data[index].buildTrailing(context),
                        ),
                        Divider(
                          height: 0,
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: <Widget>[
                      Dismissible(
                        key: UniqueKey(),
                        confirmDismiss: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            return Future<bool>.value(true);
                          } else if (direction == DismissDirection.endToStart) {
                            return _promptUser(direction, snapshot.data[index]);
                          }
                        },
                        direction: widget.enableSwipeRight
                            ? DismissDirection.horizontal
                            : DismissDirection.endToStart,
                        background: SwipeRightBackground(
                            type: snapshot.data[index].type),
                        secondaryBackground: SwipeLeftBackground(),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            _updateType(snapshot.data[index]);
                          } else {
                            setState(() {
                              readingList.remove(snapshot.data[index]);
                            });
                            Scaffold.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.grey[600],
                                content: Text("Book deleted from list.")));
                          }
                        },
                        child: ListTile(
                          leading: snapshot.data[index].buildLeading(context),
                          title: snapshot.data[index].buildTitle(context),
                          subtitle: snapshot.data[index].buildSubtitle(context),
                          trailing: snapshot.data[index].buildTrailing(context),
                          onTap: () {
                            _navigateToBookDetails(
                                context, snapshot.data[index].bookId);
                          },
                        ),
                      ),
                      Divider(
                        height: 0,
                      ),
                    ],
                  );
                }),
          );
        },
      ),
    );
  }
}
