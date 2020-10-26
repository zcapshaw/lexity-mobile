import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class AddNoteScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AddNoteScreen());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthenticationBloc>().state.user;
    final book = context.bloc<BookDetailsCubit>().state.book;
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
              // If note isn't null or empty string emit a NoteAdded event
              if (note != null && note.isNotEmpty) {
                context
                    .bloc<ReadingListBloc>()
                    .add(NoteAdded(book, user, note));
              }
              //return to BookDetails
              Navigator.pop(context);
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
