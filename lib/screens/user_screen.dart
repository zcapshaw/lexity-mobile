import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:lexity_mobile/models/user.dart';
import 'package:lexity_mobile/utils/follower_numbers.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key key}) : super(key: key);
  @override
  _UserScreenState createState() => _UserScreenState();
}

UserModel user; //declare global variable

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserModel>(context, listen: true);
    return Scaffold(
      body: Container(
        color: Color(0xFFC3E0E0),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                child: _UserInfo(
                  profileImg: user.profileImg,
                  name: user.name,
                  username: '@${user.username}',
                  following: FollowerNumbers.converter(user.friends),
                  followers: FollowerNumbers.converter(user.followers),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: OutlineButton(
                  borderSide: BorderSide(
                    color: Color(0xFF1A6978),
                  ),
                  onPressed: () => user.logout(),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFF1A6978),
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  final String profileImg;
  final String name;
  final String username;
  final String following;
  final String followers;

  _UserInfo(
      {this.profileImg,
      this.name,
      this.username,
      this.following,
      this.followers});

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFC3E0E0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200],
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(40, 5, 40, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    child: CachedNetworkImage(
                      imageUrl: profileImg,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: imageProvider,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Icon(Icons.account_circle,
                          size: 50, color: Colors.grey[600]),
                      placeholderFadeInDuration: Duration.zero,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            name,
                            style: TextStyle(
                              color: Color(0xFF1A6978),
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
                  Container(
                    height: 50, // same height as profile image
                    child: GestureDetector(
                      onTap: () => {},
                      child: Icon(Icons.menu),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () => print('Following pressed'),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: following,
                          style: TextStyle(
                            color: Color(0xFF1A6978),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            height: 1.5,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Following',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () => print('Followers pressed'),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: followers,
                          style: TextStyle(
                            color: Color(0xFF1A6978),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            height: 1.5,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Followers',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
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
