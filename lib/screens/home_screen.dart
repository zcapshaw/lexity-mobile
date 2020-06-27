import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lexity_mobile/components/reading_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              ReadingList(),
            ],
          ),
        ),
      ),
    );
  }
}

// Future<List<Book>> _getToReadList() async {
//   final String user = 'Users/77198';

//   var data = await http.get(
//       'https://stellar-aurora-280316.uc.r.appspot.com/list/summary/$user');
//   var toReadJson = jsonDecode(data.body)['TO_READ'];
//   List<Book> toReadList = [];

//   for (var b in toReadJson) {
//     Book book = Book(b['title'], b['authors'][0]);
//     toReadList.add(book);
//   }
//   setState(() {
//     wantToReadCount = toReadList.length;
//   });
//   return toReadList;
// }

// class Book {
//   final String title;
//   final String author;

//   Book(this.title, this.author);

//   Widget buildTitle(BuildContext context) => Text(title);
//   Widget buildAuthor(BuildContext context) => Text(author);
// }
