import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReadingList extends StatefulWidget {
  @override
  _ReadingListState createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {
  //Construct a List of ListItems from the API response
  Future<List<ListItem>> _getReadingList() async {
    final String user = 'Users/77198';
    List<ListItem> readingList;

    final http.Response data = await http.get(
        'https://stellar-aurora-280316.uc.r.appspot.com/list/summary/$user');

    if (data.statusCode == 200) {
      //Construct a 'readingList' array with a HeadingItem and BookItems
      var readingJson = jsonDecode(data.body)['READING'];
      readingList = [
        HeadingItem('Reading'),
      ];
      for (var b in readingJson) {
        BookItem book = BookItem(b['title'], b['authors'][0], b['cover']);
        readingList.add(book);
      }

      //Construct a 'toRead' array with a HeadingItem and BookItems
      var toReadJson = jsonDecode(data.body)['TO_READ'];
      List<ListItem> toRead = [
        HeadingItem('Want to read'),
      ];
      for (var b in toReadJson) {
        BookItem book = BookItem(b['title'], b['authors'][0], b['cover']);
        toRead.add(book);
      }

      //Combine the 'readingList' and 'toRead' lists into one List to render
      readingList.addAll(toRead);
    } else {
      print(data.statusCode);
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
            return Container(
              child: Center(
                child: Text('Loading...'),
              ),
            );
          }

          return Flexible(
            child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: snapshot.data[index].buildLeading(context),
                        title: snapshot.data[index].buildTitle(context),
                        subtitle: snapshot.data[index].buildSubtitle(context),
                        trailing: snapshot.data[index].buildTrailing(context),
                      ),
                      Divider()
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
abstract class ListItem {
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
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
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

/// A ListItem that contains data to display a message.
class BookItem implements ListItem {
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
