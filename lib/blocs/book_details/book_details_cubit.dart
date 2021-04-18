import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lexity_mobile/models/listed_book.dart';
import 'package:lexity_mobile/models/note.dart';
import 'package:meta/meta.dart';

import '../blocs.dart';

part 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  BookDetailsCubit(this.readingListBloc) : super(const BookDetailsLoading()) {
    readingListSubscription = readingListBloc.listen((state) {
      if (state is ReadingListLoadSuccess) {
        // listen for changes to the reading list
        // update the state object in BookDetailsCubit if needed
        getCurrentBookFromReadingList(state.readingList);
      }
    });
  }

  final ReadingListBloc readingListBloc;
  StreamSubscription readingListSubscription;

  void getCurrentBookFromReadingList(List<ListedBook> readingList) {
    // find the currently selected book in the new reading list
    // return null if it doesn't exist
    if (state.book != null) {
      var updatedBook = readingList
          .firstWhere((b) => b.bookId == state.book.bookId, orElse: () => null);
      if (updatedBook != null) {
        viewBookDetails(updatedBook);
      }
    }
  }

  void closeBookDetails() {
    emit(const BookDetailsLoading());
  }

  void viewBookDetails(ListedBook book) {
    var recos = getRecosFromBook(book);
    var notes = getNotesFromBook(book);

    if (book.type == 'READING') {
      emit(BookDetailsReading(book, recos, notes));
    } else if (book.type == 'TO_READ') {
      emit(BookDetailsWantToRead(book, recos, notes));
    } else if (book.type == 'READ') {
      emit(BookDetailsFinished(book, recos, notes));
    } else {
      emit(BookDetailsUnlisted(book, recos, notes));
    }
  }

  List<Note> getRecosFromBook(ListedBook book) {
    var recosWithoutNotes = <Note>[];

    if (book.notes != null) {
      recosWithoutNotes = List<Note>.from(book.notes)
        ..removeWhere((n) => n.isReco == false);
    }

    return recosWithoutNotes;
  }

  List<Note> getNotesFromBook(ListedBook book) {
    var notesWithoutRecos = <Note>[];

    if (book.notes != null) {
      notesWithoutRecos = List<Note>.from(book.notes)
        ..removeWhere((n) => n.isReco == true);
    }

    return notesWithoutRecos;
  }

  @override
  Future<void> close() {
    readingListSubscription?.cancel(); // '?' provides null safety for tests
    return super.close();
  }
}
