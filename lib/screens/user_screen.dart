import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexity_mobile/blocs/blocs.dart';

import '../blocs/blocs.dart';
import '../components/reading_list.dart';
import '../models/user.dart';
import '../utils/follower_numbers.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key key}) : super(key: key);
  @override
  _UserScreenState createState() => _UserScreenState();
}

User user; //declare global variable

class _UserScreenState extends State<UserScreen> {
  final readList = ReadingList(
      includedTypes: ['READ'], enableHeaders: false, enableSwipeRight: false);
  int selectedIndex = 0;
  List<bool> listStatus = [true, false];

  // Allowed stateless _ToggleButtons to pass selected index
  void buttonCallback(int selected) {
    var tempStatus = [false, false];
    tempStatus[selected] = true;
    setState(() {
      listStatus = tempStatus;
      selectedIndex = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = context.bloc<AuthenticationBloc>().state.user;
    return Scaffold(
      body: Container(
        color: const Color(0xFFC3E0E0),
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
                readList,

                // For now, commenting out toggle buttons, as we don't have
                // any additional data or design to leverage at this time

                // _ToggleButtons(
                //   selectedIndex: selectedIndex,
                //   listStatus: listStatus,
                //   callback: buttonCallback,
                // ),
                // if (selectedIndex == 0) readList,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  _UserInfo(
      {this.profileImg,
      this.name,
      this.username,
      this.following,
      this.followers,
      this.booksRead});

  final String profileImg;
  final String name;
  final String username;
  final String following;
  final String followers;
  final String booksRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC3E0E0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(40, 5, 40, 10),
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
                        margin: const EdgeInsets.only(left: 15),
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Color(0xFF1A6978),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.2,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
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
                        shape: const RoundedRectangleBorder(
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
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: () => print('Following pressed'),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: following,
                        style: const TextStyle(
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
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: () => print('Followers pressed'),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: followers,
                        style: const TextStyle(
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
                  child: BlocBuilder<StatsCubit, StatsState>(
                      builder: (context, state) {
                    if (state is StatsLoadSuccess) {
                      return RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: FollowerNumbers.converter(state.readCount ?? 0),
                          style: const TextStyle(
                            color: Color(0xFF1A6978),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            height: 1.5,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: state.readCount == 1 ? ' Book' : ' Books',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(vertical: 5),
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  borderSide: const BorderSide(
                    color: Color(0xFF1A6978),
                  ),
                  onPressed: () {
                    context.bloc<AuthenticationBloc>().add(const LoggedOut());
                  },
                  child: const Text(
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
      },
    );
  }
}

class _ToggleButtons extends StatelessWidget {
  _ToggleButtons({this.selectedIndex, this.listStatus, this.callback});

  final int selectedIndex;
  final List<bool> listStatus;
  final void Function(int) callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10),
      child: ToggleButtons(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.50,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: listStatus[0] ? Colors.grey[700] : Colors.transparent,
                  width: 1.5,
                ),
              ),
            ),
            child: const Icon(Icons.collections_bookmark),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.50,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: listStatus[1] ? Colors.grey[700] : Colors.transparent,
                  width: 1.5,
                ),
              ),
            ),
            child: const Icon(Icons.chat),
          ),
        ],
        isSelected: listStatus,
        onPressed: callback,
        renderBorder: false,
        //borderRadius: BorderRadius.circular(4),
        fillColor: Colors.transparent,
        //selectedBorderColor: Colors.teal,
        selectedColor: Colors.grey[700],
        color: Colors.grey[500],
        constraints: const BoxConstraints(minHeight: 30, minWidth: 110),
      ),
    );
  }
}
