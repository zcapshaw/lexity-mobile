import 'package:equatable/equatable.dart';
import 'package:lexity_mobile/models/models.dart';

abstract class ReadingListState extends Equatable {
  const ReadingListState();

  @override
  List<Object> get props => [];
}

class ReadingListLoadInProgress extends ReadingListState {}

class ReadingListLoadSuccess extends ReadingListState {
  final List<ListedBook> readingList;

  const ReadingListLoadSuccess([this.readingList = const []]);

  @override
  List<Object> get props => [readingList];

  @override
  String toString() => 'ReadingListLoadSuccess';
}

class ReadingListLoadFailure extends ReadingListState {}
