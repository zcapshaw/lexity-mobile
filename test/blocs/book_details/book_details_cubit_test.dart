import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/blocs/book_details/book_details_cubit.dart';
import 'package:lexity_mobile/models/listed_book.dart';

void main() {
  ListedBook readingBook = ListedBook(type: 'READING');
  ListedBook wantToReadBook = ListedBook(type: 'TO_READ');
  ListedBook readBook = ListedBook(type: 'READ');

  group('BookDetailsCubit', () {
    test('initial state is loading', () {
      expect(BookDetailsCubit().state, BookDetailsLoading());
    });

    blocTest<BookDetailsCubit, BookDetailsState>(
      'emits [] when nothing is called',
      build: () => BookDetailsCubit(),
      expect: [],
    );

    blocTest<BookDetailsCubit, BookDetailsState>(
      'emits Reading state when viewing details on book I\'m reading',
      build: () => BookDetailsCubit(),
      act: (cubit) => cubit.viewBookDetails(readingBook),
      expect: [BookDetailsReading(readingBook)],
    );

    blocTest<BookDetailsCubit, BookDetailsState>(
      'emits WantToRead state when viewing details on book I want to read',
      build: () => BookDetailsCubit(),
      act: (cubit) => cubit.viewBookDetails(wantToReadBook),
      expect: [BookDetailsWantToRead(wantToReadBook)],
    );

    blocTest<BookDetailsCubit, BookDetailsState>(
      'emits Read state when viewing details on book I\'ve read',
      build: () => BookDetailsCubit(),
      act: (cubit) => cubit.viewBookDetails(readBook),
      expect: [BookDetailsFinished(readBook)],
    );
  });
}
