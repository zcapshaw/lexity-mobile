import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../screens/book_detail_screen.dart';
import 'swipe_background.dart';
import '../models/reading_list_item.dart';
import '../models/user.dart';
import 'book_list_bloc.dart';

class ReadList extends StatefulWidget {
  //final ValueNotifier<int> booksReadCount = ValueNotifier(readCount);

  @override
  _ReadListState createState() => _ReadListState();
}

class _ReadListState extends State<ReadList> {
  List<ReadingListItem> readList; // declare read list
  UserModel user;

  @override
  initState() {
    super.initState();

    // assign user for access to UserModel methods
    user = Provider.of<UserModel>(context, listen: false);
  }

  //Construct a List of ListItems from the API response
  Future<List<ReadingListItem>> _getReadList() async {
    final http.Response data = await http.get(
        'https://stellar-aurora-280316.uc.r.appspot.com/list/summary/?userId=${user.id}',
        headers: {
          'access-token': '${user.accessToken}',
        });

    if (data.statusCode == 200) {
      var readJson = jsonDecode(data.body)['READ'];
      int readCount = readJson.length;
      bookListBloc.updateReadCount(readCount);

      readList = [];
      for (var b in readJson) {
        String title = b['title'];
        if (b['subtitle'] != null) title = '$title: ${b['subtitle']}';
        BookItem book = BookItem(title, b['authors'][0], b['cover'],
            b['listId'], b['bookId'], b['type']);
        readList.add(book);
      }
    } else {
      print(data.statusCode);
      print(data.reasonPhrase);
    }

    return readList;
  }

  Future<void> _deleteBook(listId) async {
    final http.Response res = await http.delete(
        'https://stellar-aurora-280316.uc.r.appspot.com/list/delete/?userId=${user.id}&listId=$listId',
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
                  // Dismiss the dialog and
                  // also dismiss the swiped item

                  _deleteBook(book.listId);
                  Navigator.of(context).pop(true);
                },
              ),
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  // Dismiss the dialog but don't
                  // dismiss the swiped item
                  return Navigator.of(context).pop(false);
                },
              )
            ],
          ),
        ) ??
        false; // In case the user dismisses the dialog by clicking away from it
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _getReadList(),
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
                        direction:
                            DismissDirection.endToStart, // only endToStart
                        confirmDismiss: (direction) {
                          return _promptUser(direction, snapshot.data[index]);
                        },
                        background: SwipeLeftBackground(),
                        onDismissed: (direction) {
                          setState(() {
                            readList.remove(snapshot.data[index]);
                          });
                          Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.grey[600],
                              content: Text("Book deleted from list.")));
                        },
                        child: ListTile(
                          leading: snapshot.data[index].buildLeading(context),
                          title: snapshot.data[index].buildTitle(context),
                          subtitle: snapshot.data[index].buildSubtitle(context),
                          trailing: snapshot.data[index].buildTrailing(context),
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
