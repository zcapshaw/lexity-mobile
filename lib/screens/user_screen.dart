import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lexity_mobile/models/user.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key key}) : super(key: key);
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              child: _UserInfo(
                  profileImg: user.profileImg,
                  name: user.name,
                  username: '@${user.username}'),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  String profileImg;
  String name;
  String username;
  String following;
  String follower;

  _UserInfo(
      {this.profileImg,
      this.name,
      this.username,
      this.following,
      this.follower});

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(profileImg),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      username,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey[550],
                        fontSize: 14,
                        letterSpacing: 0.2,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
