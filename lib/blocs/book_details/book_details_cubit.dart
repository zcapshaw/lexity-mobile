import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lexity_mobile/models/listed_book.dart';
import 'package:lexity_mobile/models/note.dart';
import 'package:meta/meta.dart';

part 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  BookDetailsCubit() : super(const BookDetailsLoading());

  void closeBookDetails() {
    emit(const BookDetailsLoading());
  }

  void notesUpdated(ListedBook book) {
    emit(const BookDetailsLoading());
    viewBookDetails(book);
  }

  void noteDeleted(ListedBook book, String noteId) {
    emit(const BookDetailsLoading());

    // remove the deleted note from the book and
    // emit new state to refresh the view
    var updatedNotes = List<Note>.from(book.notes)
      ..removeWhere((note) => note.id == noteId);
    book.notes = updatedNotes;

    viewBookDetails(book);
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
    var recosWithoutNotes = List<Note>.from(book.notes)
      ..removeWhere((n) => n.isReco == false);

    return recosWithoutNotes;
  }

  List<Note> getNotesFromBook(ListedBook book) {
    var notesWithoutRecos = List<Note>.from(book.notes)
      ..removeWhere((n) => n.isReco == true);

    return notesWithoutRecos;
  }
}
