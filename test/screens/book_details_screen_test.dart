import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/blocs/book_details/book_details_cubit.dart';
import 'package:lexity_mobile/models/listed_book.dart';
import 'package:lexity_mobile/screens/book_details_screen.dart';
import 'package:lexity_mobile/utils/test_keys.dart';
import 'package:mockito/mockito.dart';

class MockBookDetailscubit extends MockBloc<BookDetailsState>
    implements BookDetailsCubit {}

void main() {
  BookDetailsCubit bookDetailsCubit;

  setUp(() {
    bookDetailsCubit = MockBookDetailscubit();
    when(bookDetailsCubit.state).thenReturn(BookDetailsLoading());
  });

  tearDown(() {
    bookDetailsCubit.close();
  });

  group('BookDetailsScreen', () {
    testWidgets('renders a spinner when in the loading state',
        (WidgetTester tester) async {
      when(bookDetailsCubit.state).thenReturn(BookDetailsLoading());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bookDetailsCubit,
            child: BookDetailsScreen(),
          ),
        ),
      );
      expect(find.byKey(TestKeys.bookDetailsLoadingSpinner), findsOneWidget);
    });

    testWidgets('renders properly when a listed book is provided',
        (WidgetTester tester) async {
      ListedBook testBook = ListedBook(
        title: 'Sapiens',
        authors: ['Yuval Noah Harrari'],
        categories: ['History', 'World'],
      );
      when(bookDetailsCubit.state).thenReturn(
        BookDetailsReading(testBook),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bookDetailsCubit,
            child: BookDetailsScreen(),
          ),
        ),
      );
      expect(find.text('Yuval Noah Harrari'), findsOneWidget);
      expect(find.text('Sapiens'), findsOneWidget);
      expect(find.text('Mark Finished'), findsOneWidget);
      expect(find.byKey(TestKeys.bookDetailsGenreChip), findsOneWidget);
    });
  });
}

//--TEST CASES--
//DONE: renders spinner when loading
//renders details when details are present
//renders correct buttons
//buttons call expected bloc functions
