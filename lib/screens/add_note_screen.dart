import 'package:flutter/material.dart';

class AddNoteScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AddNoteScreen());
  }

  @override
  Widget build(BuildContext context) {
    String note;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.teal[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              print(note);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                enableSuggestions: true,
                initialValue: '',
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add a note on this book',
                  hintStyle: Theme.of(context).textTheme.subtitle2,
                ),
                onChanged: (text) {
                  note = text;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
