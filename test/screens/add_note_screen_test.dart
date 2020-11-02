import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/blocs/book_details/book_details_cubit.dart';
import 'package:lexity_mobile/models/note.dart';
import 'package:lexity_mobile/models/user.dart';
import 'package:lexity_mobile/screens/add_note_screen.dart';

class MockBookDetailscubit extends MockBloc<BookDetailsState>
    implements BookDetailsCubit {}

class MockAuthenticationBoc extends MockBloc<AuthenticationState>
    implements AuthenticationBloc {}

class MockReadingListBloc extends MockBloc<ReadingListState>
    implements ReadingListBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  BookDetailsCubit bookDetailsCubit;
  AuthenticationBloc authenticationBloc;
  ReadingListBloc readingListBloc;
  NavigatorObserver mockObserver;
  var user = User();

  setUp(() {
    bookDetailsCubit = MockBookDetailscubit();
    authenticationBloc = MockAuthenticationBoc();
    readingListBloc = MockReadingListBloc();
    mockObserver = MockNavigatorObserver();
    when(bookDetailsCubit.state).thenReturn(const BookDetailsLoading());
    when(authenticationBloc.state).thenReturn(Authenticated(user));
  });

  group('AddNoteScreen', () {
    testWidgets('renders an empty state for a new note',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authenticationBloc,
            child: BlocProvider.value(
              value: bookDetailsCubit,
              child: const AddNoteScreen(),
            ),
          ),
        ),
      );
      expect(find.text('Add a note on this book'), findsOneWidget);
    });

    testWidgets('users can add a note', (WidgetTester tester) async {
      // Build the widget.
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authenticationBloc,
            child: BlocProvider.value(
              value: readingListBloc,
              child: BlocProvider.value(
                value: bookDetailsCubit,
                child: const AddNoteScreen(),
              ),
            ),
          ),
        ),
      );

      // Enter 'hi' into the TextField.
      await tester.enterText(find.byType(TextField), 'hi');

      // Expect to find the item on screen.
      expect(find.text('hi'), findsOneWidget);

      // Tap the add button.
      await tester.tap(find.text('Done'));
    });

    testWidgets('renders note text when passed a note to edit',
        (WidgetTester tester) async {
      var testNote = Note(
          id: '12345',
          comment: 'Great book',
          created: 1599787528208,
          sourceName: 'Daniel Rediger');

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authenticationBloc,
            child: BlocProvider.value(
              value: bookDetailsCubit,
              child: AddNoteScreen(
                noteId: testNote.id,
                noteText: testNote.comment,
              ),
            ),
          ),
        ),
      );
      expect(find.text('Great book'), findsOneWidget);
    });
  });
}
