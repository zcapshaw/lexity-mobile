import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReadingList extends StatefulWidget {
  @override
  _ReadingListState createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {
  //Construct a List of ListItems from the API response
  Future<List<ReadingListItem>> _getReadingList() async {
    final String user = 'Users/74763';
    final userJwt = DotEnv().env['USER_JWT'];

    List<ReadingListItem> readingList;

    final http.Response data = await http.get(
        'https://stellar-aurora-280316.uc.r.appspot.com/list/summary/?userId=$user',
        headers: {
          'user-jwt': '$userJwt',
        });

    if (data.statusCode == 200) {
      //Construct a 'readingList' array with a HeadingItem and BookItems
      var readingJson = jsonDecode(data.body)['READING'];
      int readingCount = readingJson.length;

      readingList = [
        HeadingItem('Reading ($readingCount)'),
      ];
      for (var b in readingJson) {
        BookItem book = BookItem(b['title'], b['authors'][0], b['cover']);
        readingList.add(book);
      }

      //Construct a 'toRead' array with a HeadingItem and BookItems
      var toReadJson = jsonDecode(data.body)['TO_READ'];
      int toReadCount = toReadJson.length;

      List<ReadingListItem> toRead = [
        HeadingItem('Want to read ($toReadCount)'),
      ];
      for (var b in toReadJson) {
        BookItem book = BookItem(b['title'], b['authors'][0], b['cover']);
        toRead.add(book);
      }

      //Combine the 'readingList' and 'toRead' lists into one List to render
      readingList.addAll(toRead);
    } else {
      print(data.statusCode);
      print(data.reasonPhrase);
      print(userJwt);
    }

    return readingList;
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
                  return Column(
                    children: <Widget>[
                      Dismissible(
                        key: Key(index.toString()),
                        background: Container(
                          color: Colors.redAccent[200],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
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
  final IconData icon = Icons.reorder;

  BookItem(this.title, this.subtitle, this.cover);

  Widget buildTitle(BuildContext context) => Text(title);
  Widget buildSubtitle(BuildContext context) => Text(subtitle);
  Widget buildTrailing(BuildContext context) => Icon(icon);
  Widget buildLeading(BuildContext context) => Image.network(cover);
}
