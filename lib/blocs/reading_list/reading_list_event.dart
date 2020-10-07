import 'package:equatable/equatable.dart';
import 'package:lexity_mobile/models/models.dart';

abstract class ReadingListEvent extends Equatable {
  const ReadingListEvent();

  @override
  List<Object> get props => [];
}

class ReadingListLoaded extends ReadingListEvent {}

class ReadingListRefreshed extends ReadingListEvent {}

class ReadingListAdded extends ReadingListEvent {
  final ListedBook book;

  const ReadingListAdded(this.book);

  @override
  List<Object> get props => [book];

  @override
  String toString() => 'ReadingListAdded { book: $book }';
}

class ReadingListUpdated extends ReadingListEvent {
  final ListedBook book;

  const ReadingListUpdated(this.book);

  @override
  List<Object> get props => [book];

  @override
  String toString() => 'ReadingListUpdated { book: $book }';
}

class ReadingListDeleted extends ReadingListEvent {
  final ListedBook book;

  const ReadingListDeleted(this.book);

  @override
  List<Object> get props => [book];

  @override
  String toString() => 'ReadingListDeleted { book: $book }';
}
