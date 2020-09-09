import 'package:flutter/material.dart';

import 'book_list_bloc.dart';

class ListTileHeader extends StatelessWidget {
  final String type;

  ListTileHeader({@required this.type, @required Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return ListTile(
      title: BuildTitle(type),
      subtitle: null,
      trailing: null,
      leading: null,
    );
  }
}

class BuildTitle extends StatelessWidget {
  final String headingType;

  BuildTitle(this.headingType);

// Construct Header text based on list type
  String _getHeaderText(String type, int count) {
    String headerText;
    switch (type) {
      case 'READING':
        {
          headerText = 'Reading ($count)';
        }
        break;
      case 'TO_READ':
        {
          headerText = 'Want to read ($count)';
        }
        break;
      case 'READ':
        {
          headerText = 'Read ($count)';
        }
        break;
      default:
        {
          headerText = '';
        }
        break;
    }
    return headerText;
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bookListBloc.listCount, // Stream getter
        initialData: {},
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              _getHeaderText(headingType, snapshot.data[headingType] ?? 0),
              style: Theme.of(context).textTheme.headline6,
            ),
          );
        });
  }
}
