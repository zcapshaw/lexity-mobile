import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReadingList extends StatefulWidget {
  @override
  _ReadingListState createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {
  final items = List<ListItem>.generate(
    12,
    (i) => i % 6 == 0
        ? HeadingItem("Heading $i")
        : BookItem("Title $i", "Author $i"),
  );

  Future<List<ListItem>> _getReadingList() async {
    final String user = 'Users/77198';

    var data = await http.get(
        'https://stellar-aurora-280316.uc.r.appspot.com/list/summary/$user');

    //JSON for the Reading portion of the response object
    var readingJson = jsonDecode(data.body)['READING'];
    List<ListItem> reading = [
      HeadingItem('Reading'),
      BookItem('Title 1', 'Author 1')
    ];

    // for (var b in toReadJson) {
    //   Book book = Book(
    //       title: b['title'], author: b['authors'][0], coverImage: b['cover']);
    //   toReadList.add(book);
    // }
    print(reading);
    return reading;
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
            child: ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: snapshot.data[index].buildTitle(context),
                    subtitle: snapshot.data[index].buildSubtitle(context),
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
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;
}

/// A ListItem that contains data to display a message.
class BookItem implements ListItem {
  final String sender;
  final String body;

  BookItem(this.sender, this.body);

  Widget buildTitle(BuildContext context) => Text(sender);

  Widget buildSubtitle(BuildContext context) => Text(body);
}
