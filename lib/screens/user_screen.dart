import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../components/reading_list.dart';
import '../models/user.dart';
import '../utils/follower_numbers.dart';
import '../components/book_list_bloc.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key key}) : super(key: key);
  @override
  _UserScreenState createState() => _UserScreenState();
}

UserModel user; //declare global variable

class _UserScreenState extends State<UserScreen> {
  final readList = ReadingList(
      types: ['READ'], enableHeaders: false, enableSwipeRight: false);
  int selectedIndex = 0;
  List<bool> listStatus = [true, false];

  // Allowed stateless _ToggleButtons to pass selected index
  buttonCallback(int selected) {
    List<bool> tempStatus = [false, false];
    tempStatus[selected] = true;
    setState(() {
      listStatus = tempStatus;
      selectedIndex = selected;
    });
  }

  @override
  void dispose() {
    super.dispose();
    // opting not to close the stream which is shared by user_screen and read_list
    // bookListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserModel>(context, listen: true);
    return Scaffold(
      body: Container(
        color: Color(0xFFC3E0E0),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  child: _UserInfo(
                    profileImg: user.profileImg,
                    name: user.name,
                    username: '@${user.username}',
                    following: FollowerNumbers.converter(user.friends),
                    followers: FollowerNumbers.converter(user.followers),
                    booksRead: FollowerNumbers.converter(0),
                  ),
                ),
                _ToggleButtons(
                  selectedIndex: selectedIndex,
                  listStatus: listStatus,
                  callback: buttonCallback,
                ),
                if (selectedIndex == 0) readList,
              ],
            ),
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
  final String booksRead;

  _UserInfo(
      {this.profileImg,
      this.name,
      this.username,
      this.following,
      this.followers,
      this.booksRead});
  Widget build(BuildContext context) {
    return Container(
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
                    onTap: () => {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        builder: (BuildContext context) => _UserMenu(),
                      )
                    },
                    child: Icon(Icons.menu, color: Colors.grey[700]),
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
                  padding: EdgeInsets.only(right: 15),
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
                Container(
                  child: StreamBuilder(
                      stream: bookListBloc.listCount, // Stream getter
                      initialData: {},
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: FollowerNumbers.converter(
                                snapshot.data['READ'] ?? 0),
                            style: TextStyle(
                              color: Color(0xFF1A6978),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              height: 1.5,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: snapshot.data['READ'] == 1
                                    ? ' Book'
                                    : ' Books',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserMenu extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          Container(
            child: Icon(
              Icons.maximize,
              size: 36,
              color: Colors.grey[700],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: OutlineButton(
              padding: EdgeInsets.symmetric(vertical: 15),
              borderSide: BorderSide(
                color: Color(0xFF1A6978),
              ),
              onPressed: () => user.logout(),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFF1A6978),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButtons extends StatelessWidget {
  final int selectedIndex;
  final List<bool> listStatus;
  final Function(int) callback;

  _ToggleButtons({this.selectedIndex, this.listStatus, this.callback});

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      child: ToggleButtons(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.50,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: listStatus[0] ? Colors.grey[700] : Colors.transparent,
                  width: 1.5,
                ),
              ),
            ),
            child: Icon(Icons.collections_bookmark),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.50,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: listStatus[1] ? Colors.grey[700] : Colors.transparent,
                  width: 1.5,
                ),
              ),
            ),
            child: Icon(Icons.chat),
          ),
        ],
        isSelected: listStatus,
        onPressed: (int index) {
          callback(index);
        },
        renderBorder: false,
        //borderRadius: BorderRadius.circular(4),
        fillColor: Colors.transparent,
        //selectedBorderColor: Colors.teal,
        selectedColor: Colors.grey[700],
        color: Colors.grey[500],
        constraints: BoxConstraints(minHeight: 30, minWidth: 110),
      ),
    );
  }
}
