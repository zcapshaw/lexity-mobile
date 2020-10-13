import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexity_mobile/blocs/blocs.dart';

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
    return BlocBuilder<StatsCubit, StatsState>(builder: (context, state) {
      return Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: 30, bottom: 10),
        child: Text(
          (state is StatsLoadSuccess)
              ? _getHeaderText(headingType, state.countByType(headingType))
              : _getHeaderText(headingType, 0),
          style: Theme.of(context).textTheme.headline6,
        ),
      );
    });
  }
}
