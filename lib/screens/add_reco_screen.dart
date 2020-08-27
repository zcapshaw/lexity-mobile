import 'package:flutter/material.dart';

import '../components/list_tile_text_field.dart';

class AddRecoScreen extends StatefulWidget {
  const AddRecoScreen({Key key, this.recoSource, this.recoText, this.userId})
      : super(key: key);

  final String recoSource;
  final String recoText;
  final String userId; // To be used with lexity and/or twitter search

  @override
  _AddRecoScreenState createState() => _AddRecoScreenState();
}

class _AddRecoScreenState extends State<AddRecoScreen> {
  String recoSource;
  String recoText;

  @override
  void initState() {
    recoSource = widget.recoSource;
    // if you fully remove recoSource, recoText will render as empty
    recoText = recoSource.toString().length == 0 ? null : widget.recoText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Recos',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(
                  context, {'recoSource': recoSource, 'recoText': recoText});
            },
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.teal[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            children: <Widget>[
              TextFieldTile(
                intialValue: recoSource,
                headerText: 'Who recommended this book to you?',
                hintText: 'Type a name',
                maxLines: 1,
                onTextChange: (text) {
                  setState(() {
                    recoSource = text;
                  });
                },
              ),
              Divider(),
              TextFieldTile(
                intialValue: recoText,
                headerText: 'Notes',
                hintText: 'Add a note about what they said...',
                maxLines: null,
                onTextChange: (text) {
                  setState(() {
                    recoText = text;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
