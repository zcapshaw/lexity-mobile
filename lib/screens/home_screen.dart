import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lexity_mobile/models/user.dart';
import 'package:lexity_mobile/components/reading_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/bookSearch');
        },
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
