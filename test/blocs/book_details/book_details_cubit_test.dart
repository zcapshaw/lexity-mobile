import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/blocs/book_details/book_details_cubit.dart';
import 'package:lexity_mobile/models/listed_book.dart';
import 'package:lexity_mobile/models/note.dart';
import 'package:mockito/mockito.dart';

class MockReadingList extends Mock implements ReadingListBloc {}

void main() {
  var testNote = Note(id: '123', comment: 'comment');
  var readingBook = ListedBook(type: 'READING');
  var wantToReadBook = ListedBook(type: 'TO_READ');
  var readBook = ListedBook(type: 'READ', title: 'Sapiens', notes: [testNote]);
  ReadingListBloc readingList;
  BookDetailsCubit bookDetailsCubit;

  setUp(() {
    readingList = MockReadingList();
    bookDetailsCubit = BookDetailsCubit(readingList);
  });

  group('BookDetailsCubit', () {
    test('initial state is loading', () {
      expect(bookDetailsCubit.state, const BookDetailsLoading());
    });

    blocTest<BookDetailsCubit, BookDetailsState>(
      'emits [] when nothing is called',
      build: () => bookDetailsCubit,
      expect: <BookDetailsState>[],
    );

    blocTest<BookDetailsCubit, BookDetailsState>(
      'emits Reading state when viewing details on book I\'m reading',
      build: () => bookDetailsCubit,
      act: (cubit) => cubit.viewBookDetails(readingBook),
      expect: <BookDetailsState>[BookDetailsReading(readingBook, [], [])],
    );

    blocTest<BookDetailsCubit, BookDetailsState>(
      'emits WantToRead state when viewing details on book I want to read',
      build: () => BookDetailsCubit(readingList),
      act: (cubit) => cubit.viewBookDetails(wantToReadBook),
      expect: <BookDetailsState>[BookDetailsWantToRead(wantToReadBook, [], [])],
    );

    blocTest<BookDetailsCubit, BookDetailsState>(
      'emits Read state when viewing details on book I\'ve read',
      build: () => BookDetailsCubit(readingList),
      act: (cubit) => cubit.viewBookDetails(readBook),
      expect: <BookDetailsState>[
        BookDetailsFinished(readBook, [], [testNote])
      ],
    );
  });
}
