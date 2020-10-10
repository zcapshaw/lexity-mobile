import 'package:flutter/material.dart';

import 'package:lexity_mobile/components/reading_list.dart';
import 'package:lexity_mobile/screens/book_search_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookSearchScreen(origin: Origin.fab)));
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  'Reading List',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              ReadingList(
                includedTypes: ['READING', 'TO_READ'],
                isHomescreen: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
