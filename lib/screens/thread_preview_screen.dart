import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:lexity_mobile/utils/test_keys.dart';

class ThreadPreviewScreen extends StatelessWidget {
  const ThreadPreviewScreen();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ThreadPreviewScreen());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthenticationBloc>().state.user;
    final notes = context.bloc<NotesCubit>().state.notes;

    var selectedNotes = List<SelectableNote>.from(notes)
      ..removeWhere((n) => n.selected == false)
      ..toList();

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Preview Thread',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              child: const Text(
                'Tweet',
              ),
              onPressed: () {},
            ),
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    for (var note in selectedNotes)
                      TweetPreviewCard(note, user.profileImg),
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

class TweetPreviewCard extends StatelessWidget {
  TweetPreviewCard(this.note, this.profileImg);

  final SelectableNote note;
  final String profileImg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(profileImg ?? ''),
              backgroundColor: Colors.grey[600],
            ),
            title: Text(
              note.comment,
            ),
            onTap: () {
              context.bloc<NotesCubit>().toggleSelection(note);
            },
          ),
        ),
        const Divider(),
      ],
    );
  }
}
