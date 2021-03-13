import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexity_mobile/blocs/notes/notes_cubit.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:lexity_mobile/utils/utils.dart';

import '../blocs/blocs.dart';

class SelectNotesScreen extends StatelessWidget {
  const SelectNotesScreen({this.notes});

  final List<Note> notes;

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SelectNotesScreen());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthenticationBloc>().state.user;
    final book = context.bloc<BookDetailsCubit>().state.book;

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
            TextButton(
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.teal[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                        child: Text(
                          '${state.notes.length} selected',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const Divider(),
                      for (var note in state.notes)
                        NoteSelectorCard(
                          noteText: note ?? '',
                        ),
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
        ));
  }
}

class NoteSelectorCard extends StatelessWidget {
  const NoteSelectorCard({this.noteText});

  final String noteText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    noteText,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Checkbox(
                    value: true,
                    onChanged: null,
                  ),
                )
              ],
            ),
          ),
          onTap: () {},
        ),
        const Divider(),
      ],
    );
  }
}
