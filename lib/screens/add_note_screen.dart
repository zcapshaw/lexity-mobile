import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({this.noteId, this.noteText});

  final String noteId;
  final String noteText;

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AddNoteScreen());
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
          icon: const Icon(Icons.arrow_back),
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
              // if editing an existing note, emit NoteUpdated event
              if (noteId != null) {
                context.bloc<ReadingListBloc>().add(NoteUpdated(
                    book: book, user: user, noteId: noteId, noteText: note));
              }

              // If note isn't null or empty string emit a NoteAdded event
              else if (note != null && note.isNotEmpty) {
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
                initialValue: noteText ?? '',
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
