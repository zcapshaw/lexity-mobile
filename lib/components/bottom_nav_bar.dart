import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int index;

  BottomNavBar(this.index);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          title: SizedBox.shrink(),
        ),
      ],
      currentIndex: index,
      backgroundColor: Colors.grey[200],
    );
  }
}
