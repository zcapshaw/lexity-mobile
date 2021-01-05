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
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
                const Text(
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
  SwipeRightBackground({this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal[500],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  type == 'READING' ? Icons.check : Icons.play_circle_filled,
                  color: Colors.white,
                ),
                Text(
                  type == 'READING' ? 'Complete' : 'Start',
                  style: const TextStyle(
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
