import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexity_mobile/blocs/notes/notes_cubit.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:lexity_mobile/screens/thread_preview_screen.dart';
import 'package:lexity_mobile/utils/utils.dart';

import '../blocs/blocs.dart';

class SelectNotesScreen extends StatelessWidget {
  const SelectNotesScreen();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SelectNotesScreen());
  }

  Future<void> _showExplainerDialog(BuildContext context) async {
    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Select at least one note to proceed.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final user = context.bloc<AuthenticationBloc>().state.user;
    // final book = context.bloc<BookDetailsCubit>().state.book;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: TextButton(
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Notes to Tweet',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: <Widget>[
          BlocBuilder<NotesCubit, NotesState>(
            builder: (context, state) {
              if (state.selectedCount == 0) {
                return TextButton(
                  style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.grey[300]),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                  onPressed: () {
                    _showExplainerDialog(context);
                  },
                );
              } else {
                return TextButton(
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push<void>(context, ThreadPreviewScreen.route());
                  },
                );
              }
            },
          )
        ],
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state is NotesInitial) {
            return Center(
              key: TestKeys.bookDetailsLoadingSpinner,
              child: const CircularProgressIndicator(),
            );
          } else if (state.notes != null) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                      child: Text(
                        '${state.selectedCount} selected',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    const Divider(),
                    for (var note in state.notes) NoteSelectorCard(note),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Oops. Something went wrong.'),
            );
          }
        },
      ),
    );
  }
}

class NoteSelectorCard extends StatelessWidget {
  NoteSelectorCard(this.note);

  final SelectableNote note;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Checkbox(
            value: note.selected,
            onChanged: (value) {
              context.bloc<NotesCubit>().toggleSelection(note);
            },
          ),
          title: Text(
            note.comment,
          ),
          onTap: () {
            context.bloc<NotesCubit>().toggleSelection(note);
          },
        ),
        const Divider(),
      ],
    );
  }
}
