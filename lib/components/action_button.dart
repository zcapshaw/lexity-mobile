import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
      {@required this.icon, this.labelText, @required this.callback, Key key})
      : super(key: key);

  final IconData icon;
  final String labelText;
  final void Function() callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: callback,
            color: Colors.grey[200],
            textColor: Colors.white,
            elevation: 0,
            child: Icon(
              icon,
              size: 24,
              color: Colors.grey[700],
            ),
            padding: const EdgeInsets.all(16),
            shape: const CircleBorder(),
          ),
        ),
        Text(labelText),
      ],
    );
  }
}
