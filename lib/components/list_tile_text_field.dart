import 'package:flutter/material.dart';

import './list_tile_header_text.dart';

class TextFieldTile extends StatelessWidget {
  TextFieldTile(
      {@required this.onTextChange,
      @required this.maxLines,
      this.onSubmitted,
      this.headerText = '',
      this.hintText,
      this.intialValue,
      this.focusNode,
      this.controller,
      this.bgColor = Colors.transparent});

  final void Function(String) onTextChange;
  final int maxLines;
  final void Function(String) onSubmitted;
  final String headerText;
  final String hintText;
  final String intialValue;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTileHeaderText(headerText),
          TextFormField(
            focusNode: focusNode,
            controller: controller,
            initialValue: intialValue,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.subtitle2,
            ),
            maxLines: maxLines,
            onChanged: onTextChange,
            onFieldSubmitted: onSubmitted,
            style: TextStyle(backgroundColor: bgColor),
          )
        ],
      ),
    );
  }
}
