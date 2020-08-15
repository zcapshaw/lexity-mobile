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
            padding: EdgeInsets.only(right: 16),
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
  final String type;

  SwipeRightBackground({this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal[500],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  this.type == 'READING'
                      ? Icons.check
                      : Icons.play_circle_filled,
                  color: Colors.white,
                ),
                Text(
                  this.type == 'READING' ? 'Complete' : 'Start',
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
