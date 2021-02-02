import 'package:flutter/material.dart';

import 'package:lexity_mobile/screens/home_screen.dart';
import 'package:lexity_mobile/screens/user_screen.dart';
import 'book_search_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MainScreen());
  }

  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _returnHome() {
    // dismiss OS keyboard
    FocusScope.of(context).unfocus();

    //return to home screen
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            HomeScreen(),
            BookSearchScreen(
              origin: Origin.navSearch,
              navCallback: _returnHome,
            ),
            UserScreen()
          ],
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }
}
