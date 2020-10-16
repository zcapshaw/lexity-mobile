import 'package:equatable/equatable.dart';
import 'package:lexity_mobile/models/models.dart';

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
