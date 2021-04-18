import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/models/note.dart';
import 'package:lexity_mobile/models/selectable_note.dart';
import 'package:lexity_mobile/services/twitter_service.dart';
import 'package:mockito/mockito.dart';

class MockTwitterService extends Mock implements TwitterService {}

void main() {
  var testNote1 = Note(id: '123', comment: 'comment');
  var testNote2 = Note(id: '456', comment: 'asdf');
  var selectableNote1 =
      SelectableNote(id: '123', comment: 'comment', selected: true);
  var selectableNote2 =
      SelectableNote(id: '456', comment: 'asdf', selected: true);
  var notesList = [testNote1, testNote2];
  var selectableNotesList = [
    selectableNote1,
    selectableNote2,
  ];

  TwitterService twitterService;
  NotesCubit notesCubit;

  setUp(() {
    twitterService = MockTwitterService();
    notesCubit = NotesCubit(twitterService: twitterService);
  });

  group('NotesCubit', () {
    test('initial state is NotesInitial', () {
      expect(notesCubit.state, NotesInitial());
    });

    blocTest<NotesCubit, NotesState>(
      'loadNotes emits state with notes array, text array, and tweet count',
      build: () => notesCubit,
      act: (cubit) => cubit.loadNotes(notesList),
      expect: <NotesState>[
        NotesLoaded(selectableNotesList, ['comment', 'asdf'], 2)
      ],
    );

    blocTest<NotesCubit, NotesState>(
      'toggleSelection unselects the specified note',
      build: () => notesCubit,
      seed: NotesLoaded(selectableNotesList, ['comment', 'asdf'], 2),
      act: (cubit) => cubit.toggleSelection(selectableNote1),
      expect: <NotesState>[
        NotesLoaded([
          SelectableNote(id: '123', comment: 'comment', selected: false),
          selectableNote2
        ], [
          'comment',
          'asdf'
        ], 2)
      ],
    );
  });
}
