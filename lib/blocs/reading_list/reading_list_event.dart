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
  String toString() => 'ReadingListLoaded { user: $user }';
}

class ReadingListRefreshed extends ReadingListEvent {
  const ReadingListRefreshed(this.user);

  final User user;

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'ReadingListRefreshed { user: $user }';
}

class ReadingListAdded extends ReadingListEvent {
  const ReadingListAdded(this.book);

  final ListedBook book;

  @override
  List<Object> get props => [book];

  @override
  String toString() => 'ReadingListAdded { book: $book }';
}

class ReadingListUpdated extends ReadingListEvent {
  const ReadingListUpdated(this.updatedBook);

  final ListedBook updatedBook;

  @override
  List<Object> get props => [updatedBook];

  @override
  String toString() => 'ReadingListUpdated { updatedBook: $updatedBook }';
}

class ReadingListReordered extends ReadingListEvent {
  const ReadingListReordered(this.oldIndex, this.newIndex,
      {this.isHomescreen = false});

  final int oldIndex;
  final int newIndex;
  final bool isHomescreen;

  @override
  List<Object> get props => [oldIndex, newIndex];

  @override
  String toString() =>
      'ReadingListReordered { oldIndex: $oldIndex, newIndex: $newIndex, isHomescreen: $isHomescreen }';
}

class ReadingListDeleted extends ReadingListEvent {
  const ReadingListDeleted(this.book);

  final ListedBook book;

  @override
  List<Object> get props => [book];

  @override
  String toString() => 'ReadingListDeleted { book: $book }';
}

class ReadingListDismount extends ReadingListEvent {}
