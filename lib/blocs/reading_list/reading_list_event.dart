part of './reading_list_bloc.dart';

abstract class ReadingListEvent extends Equatable {
  const ReadingListEvent();

  @override
  List<Object> get props => [];
}

class ReadingListLoaded extends ReadingListEvent {
  const ReadingListLoaded(this.user);

  final User user;

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'ReadingListLoaded { user: ${user.id} }';
}

class ReadingListRefreshed extends ReadingListEvent {
  const ReadingListRefreshed(this.user);

  final User user;

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'ReadingListRefreshed { user: ${user.id} }';
}

class ReadingListAdded extends ReadingListEvent {
  const ReadingListAdded(this.book, this.user);

  final ListedBook book;
  final User user;

  @override
  List<Object> get props => [book, user];

  @override
  String toString() =>
      'ReadingListAdded { book: ${book.bookId}, user: ${user.id} }';
}

class ReadingListUpdated extends ReadingListEvent {
  const ReadingListUpdated(this.updatedBook, this.user);

  final ListedBook updatedBook;
  final User user;

  @override
  List<Object> get props => [updatedBook, user];

  @override
  String toString() =>
      // ignore: lines_longer_than_80_chars
      'ReadingListUpdated { updatedBook: ${updatedBook.bookId}, user: ${user.id} }';
}

class ReadingListReordered extends ReadingListEvent {
  const ReadingListReordered(this.oldIndex, this.newIndex, this.user,
      {this.isHomescreen = false});

  final int oldIndex;
  final int newIndex;
  final User user;
  final bool isHomescreen;

  @override
  List<Object> get props => [oldIndex, newIndex, user];

  @override
  String toString() =>
      // ignore: lines_longer_than_80_chars
      'ReadingListReordered { oldIndex: $oldIndex, newIndex: $newIndex, user: ${user.id}, isHomescreen: $isHomescreen }';
}

class ReadingListDeleted extends ReadingListEvent {
  const ReadingListDeleted(this.book, this.user);

  final ListedBook book;
  final User user;

  @override
  List<Object> get props => [book, user];

  @override
  String toString() =>
      'ReadingListDeleted { book: ${book.bookId}, user: ${user.id} }';
}

class ReadingListDismount extends ReadingListEvent {}

//TODO - look at deleting this deprecated event - leveraging ReadingListUpdated instead
// class UpdateBookType extends ReadingListEvent {
//   const UpdateBookType(this.book, this.user, this.newType);

//   final ListedBook book;
//   final User user;
//   final String newType;

//   @override
//   List<Object> get props => [book, user, newType];

//   @override
//   String toString() =>
//       // ignore: lines_longer_than_80_chars
//       'UpdateBookType { book : ${book.bookId}, user: ${user.id}, newType: $newType }';
// }

class RecoAdded extends ReadingListEvent {
  const RecoAdded(this.book, this.user, this.reco);

  final ListedBook book;
  final User user;
  final Note reco;

  @override
  List<Object> get props => [book, user, reco];

  @override
  String toString() => 'RecoAdded { reco: $reco }';
}

class NoteAdded extends ReadingListEvent {
  const NoteAdded(this.book, this.user, this.note);

  final ListedBook book;
  final User user;
  final String note;

  @override
  List<Object> get props => [book, user, note];

  @override
  String toString() => 'NoteAdded { note: $note }';
}

class NoteDeleted extends ReadingListEvent {
  const NoteDeleted(this.noteId, this.book, this.user);

  final String noteId;
  final ListedBook book;
  final User user;

  @override
  List<Object> get props => [noteId, book, user];

  @override
  String toString() => 'NoteDeleted { noteId: $noteId }';
}

class NoteUpdated extends ReadingListEvent {
  const NoteUpdated({this.book, this.user, this.noteText, this.noteId});

  final ListedBook book;
  final User user;
  final String noteText;
  final String noteId;

  @override
  List<Object> get props => [book, user, noteText, noteId];

  @override
  String toString() => 'NoteUpdated { noteId: $noteId, comment: $noteText }';
}
