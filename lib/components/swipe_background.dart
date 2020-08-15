import 'package:flutter/material.dart';

class SwipeLeftBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SwipeRightBackground extends StatelessWidget {
  final String action;

  SwipeRightBackground({this.action});

  @override
  Widget build(BuildContext context) {
    return Container(

      color: if(action == 'COMPLETE') {
        Colors.redAccent[200];
      } else {
        Colors.blueAccent[200]
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
