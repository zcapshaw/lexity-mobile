import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/components/components.dart';
import 'package:mockito/mockito.dart';

import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/blocs/book_details/book_details_cubit.dart';
import 'package:lexity_mobile/models/listed_book.dart';
import 'package:lexity_mobile/models/note.dart';
import 'package:lexity_mobile/models/user.dart';
import 'package:lexity_mobile/screens/book_details_screen.dart';
import 'package:lexity_mobile/utils/test_keys.dart';

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
  var user = User();

  var testNote = Note(
      comment: 'Great book',
      created: 1599787528208,
      sourceName: 'Daniel Rediger');

  var testBook = ListedBook(
    title: 'Sapiens',
    authors: <String>['Yuval Noah Harrari'],
    categories: ['History', 'World'],
    description: 'Sapiens tackles big questions in vivid language.',
    notes: [testNote],
  );

  var testBookWithoutNotes = ListedBook(
    title: 'Dune',
    authors: <String>['Frank Herbert'],
    categories: ['Sci-Fi'],
    description: 'An iconic piece of science fiction',
  );

  setUp(() {
    bookDetailsCubit = MockBookDetailscubit();
    authenticationBloc = MockAuthenticationBoc();
    when(bookDetailsCubit.state).thenReturn(const BookDetailsLoading());
    when(authenticationBloc.state).thenReturn(Authenticated(user));
  });

  tearDown(() {
    bookDetailsCubit.close();
    authenticationBloc.close();
  });

  group('BookDetailsScreen', () {
    testWidgets('renders a spinner when in the loading state',
        (WidgetTester tester) async {
      when(bookDetailsCubit.state).thenReturn(const BookDetailsLoading());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authenticationBloc,
            child: BlocProvider.value(
              value: bookDetailsCubit,
              child: BookDetailsScreen(),
            ),
          ),
        ),
      );
      expect(find.byKey(TestKeys.bookDetailsLoadingSpinner), findsOneWidget);
    });

    testWidgets('renders properly when a listed book with notes is provided',
        (WidgetTester tester) async {
      when(bookDetailsCubit.state).thenReturn(
        BookDetailsReading(testBook, [], [testNote]),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authenticationBloc,
            child: BlocProvider.value(
              value: bookDetailsCubit,
              child: BookDetailsScreen(),
            ),
          ),
        ),
      );

      expect(find.text('Yuval Noah Harrari'), findsOneWidget);
      expect(find.text('Sapiens'), findsOneWidget);
      expect(find.text('Mark Finished'), findsOneWidget);
      expect(find.byKey(TestKeys.bookDetailsGenreChip), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('My Notes'), findsOneWidget);
      expect(find.byType(TwitterShareButton), findsNWidgets(1));
      expect(find.byType(ActionButton), findsNWidgets(3));
    });

    testWidgets('books without notes hide the Notes section and share button',
        (WidgetTester tester) async {
      when(bookDetailsCubit.state).thenReturn(
        BookDetailsReading(testBookWithoutNotes, [], []),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authenticationBloc,
            child: BlocProvider.value(
              value: bookDetailsCubit,
              child: BookDetailsScreen(),
            ),
          ),
        ),
      );

      expect(find.text('Dune'), findsOneWidget);
      expect(find.text('Frank Herbert'), findsOneWidget);
      expect(find.text('My Notes'), findsNothing);
      expect(find.byType(TwitterShareButton), findsNWidgets(0));
    });
  });
}

//--TEST CASES--
//DONE: renders spinner when loading
//DONE: renders details when details are present
//TODO: buttons call expected bloc functions
