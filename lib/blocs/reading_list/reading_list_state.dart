part of './reading_list_bloc.dart';

abstract class ReadingListState extends Equatable {
  const ReadingListState();

  @override
  List<Object> get props => [];
}

class ReadingListLoadInProgress extends ReadingListState {}

class ReadingListLoadSuccess extends ReadingListState {
  const ReadingListLoadSuccess(this.readingList);

  final List<ListedBook> readingList;

  @override
  List<Object> get props => [readingList];

  @override
  String toString() => 'ReadingListLoadSuccess';
}

class ReadingListLoadFailure extends ReadingListState {}
