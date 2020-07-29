import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/cupertino.dart';

import 'swipe_background.dart';
import 'package:lexity_mobile/models/reading_list_item.dart';

class ReadingList extends StatefulWidget {
  @override
  _ReadingListState createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {
  List<ReadingListItem> readingList;

  //Construct a List of ListItems from the API response
  Future<List<ReadingListItem>> _getReadingList() async {
    final String user = 'Users/74763';
    final userJwt = DotEnv().env['USER_JWT'];

    final http.Response data = await http.get(
        'https://stellar-aurora-280316.uc.r.appspot.com/list/summary/?userId=$user',
        headers: {
          'access-token': '$userJwt',
        });

    if (data.statusCode == 200) {
      //Construct a 'readingList' array with a HeadingItem and BookItems
      var readingJson = jsonDecode(data.body)['READING'];
      int readingCount = readingJson.length;

      readingList = [
        HeadingItem('Reading ($readingCount)'),
      ];
      for (var b in readingJson) {
        BookItem book =
            BookItem(b['title'], b['authors'][0], b['cover'], b['listId']);
        readingList.add(book);
      }

      //Construct a 'toRead' array with a HeadingItem and BookItems
      var toReadJson = jsonDecode(data.body)['TO_READ'];
      int toReadCount = toReadJson.length;

      List<ReadingListItem> toRead = [
        HeadingItem('Want to read ($toReadCount)'),
      ];
      for (var b in toReadJson) {
        BookItem book =
            BookItem(b['title'], b['authors'][0], b['cover'], b['listId']);
        toRead.add(book);
      }

      //Combine the 'readingList' and 'toRead' lists into one List to render
      readingList.addAll(toRead);
    } else {
      print(data.statusCode);
      print(data.reasonPhrase);
    }

    return readingList;
  }

  Future<void> _deleteBook(listId) async {
    final String user = 'Users/74763';
    final userJwt = DotEnv().env['USER_JWT'];

    final http.Response res = await http.delete(
        'https://stellar-aurora-280316.uc.r.appspot.com/list/delete/?userId=$user&listId=$listId',
        headers: {
          'access-token': '$userJwt',
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
    _getReadingList();
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
                        confirmDismiss: (direction) =>
                            _promptUser(direction, snapshot.data[index]),
                        background: SwipeBackground(),
                        //TODO: Remove this when we add more swipe actions
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            readingList.remove(snapshot.data[index]);
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
