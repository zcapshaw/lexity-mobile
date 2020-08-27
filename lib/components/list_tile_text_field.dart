import 'package:flutter/material.dart';

import './list_tile_header_text.dart';

class TextFieldTile extends StatelessWidget {
  final Function onTextChange;
  final maxLines; // not typed, as could be into OR null
  final String headerText;
  final String hintText;
  final intialValue; // not typed, as could be String OR null

  TextFieldTile(
      {@required this.onTextChange,
      @required this.maxLines,
      this.headerText = '',
      this.hintText,
      this.intialValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTileHeaderText(headerText),
          TextFormField(
            initialValue: intialValue,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.subtitle2,
            ),
            maxLines: maxLines,
            onChanged: (text) => onTextChange(text),
          )
        ],
      ),
    );
  }
}
