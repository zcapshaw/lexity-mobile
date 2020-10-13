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

  int get readingCount {
    return readingList.where((book) => book.reading).toList().length;
  }

  int get toReadCount {
    return readingList.where((book) => book.toRead).toList().length;
  }

  int get readCount {
    return readingList.where((book) => book.read).toList().length;
  }

  final int headerPlaceholder = 1;
  int get lengthWithoutRead {
    return readingList.length - this.readCount - headerPlaceholder;
  }
}

class ReadingListLoadFailure extends ReadingListState {}
