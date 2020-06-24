import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class Book {
  final String title;
  final String author;
  final String coverImage;

  Book(
      {@required this.title, @required this.author, @required this.coverImage});
}

class _HomeScreenState extends State<HomeScreen> {
  int wantToReadCount;
  int readingCount;

  Future<List<Book>> _getToReadList() async {
    final String user = 'Users/77198';

    var data = await http.get(
        'https://stellar-aurora-280316.uc.r.appspot.com/list/summary/$user');
    var toReadJson = jsonDecode(data.body)['TO_READ'];
    List<Book> toReadList = [];

    for (var b in toReadJson) {
      Book book = Book(
          title: b['title'], author: b['authors'][0], coverImage: b['cover']);
      toReadList.add(book);
    }
    setState(() {
      wantToReadCount = toReadList.length;
    });
    return toReadList;
  }

  //TODO: Refactor. This and above function are almost identical.
  Future<List<Book>> _getReadingList() async {
    final String user = 'Users/77198';

    var data = await http.get(
        'https://stellar-aurora-280316.uc.r.appspot.com/list/summary/$user');
    var toReadJson = jsonDecode(data.body)['READING'];
    List<Book> readingList = [];

    for (var b in toReadJson) {
      Book book = Book(
          title: b['title'], author: b['authors'][0], coverImage: b['cover']);
      readingList.add(book);
    }
    setState(() {
      readingCount = readingList.length;
    });
    return readingList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text(''),
          ),
        ],
        currentIndex: 0,
        backgroundColor: Colors.grey[200],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  'Reading List',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Text(
                  'Reading (${readingCount ?? ''})',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Divider(),
              Container(
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
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Image.network(
                                      snapshot.data[index].coverImage),
                                  title: Text(snapshot.data[index].title),
                                  subtitle: Text(snapshot.data[index].author),
                                  trailing: Icon(Icons.reorder),
                                ),
                              ],
                            );
                          }),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Text(
                  'Want to read (${wantToReadCount ?? ''})',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Divider(),
              Container(
                child: FutureBuilder(
                  future: _getToReadList(),
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
                                  leading: Image.network(
                                      snapshot.data[index].coverImage),
                                  title: Text(snapshot.data[index].title),
                                  subtitle: Text(snapshot.data[index].author),
                                  trailing: Icon(Icons.reorder),
                                ),
                                Divider(),
                              ],
                            );
                          }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
