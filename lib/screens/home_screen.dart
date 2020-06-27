import 'package:flutter/material.dart';

import 'package:lexity_mobile/components/reading_list.dart';
import 'package:lexity_mobile/components/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(0),
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
