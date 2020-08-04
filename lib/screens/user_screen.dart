import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lexity_mobile/models/user.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Temporary clickable logout for testing purposes
              Container(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: GestureDetector(
                  onTap: () {
                    user.logout();
                  },
                  child: Text('Test Logout'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  'Reading List',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
