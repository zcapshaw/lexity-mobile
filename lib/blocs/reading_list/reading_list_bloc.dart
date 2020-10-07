import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:lexity_mobile/blocs/reading_list/reading_list.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:lexity_mobile/services/reading_list_service.dart';

class ReadingListBloc extends Bloc<ReadingListEvent, ReadingListState> {
  final ReadingListService readingListService;

  ReadingListBloc({@required this.readingListService})
      : super(ReadingListLoadInProgress());

  @override
  Stream<ReadingListState> mapEventToState(ReadingListEvent event) async* {
    if (event is ReadingListLoaded) {
      yield* _mapReadingListLoadedToState();
    } else if (event is ReadingListRefreshed) {
      yield* _mapReadingListRefreshedToState();
    } else if (event is ReadingListAdded) {
      yield* _mapReadingListAddedToState(event);
    } else if (event is ReadingListUpdated) {
      yield* _mapReadingListUpdatedToState(event);
    } else if (event is ReadingListDeleted) {
      yield* _mapReadingListDeletedToState(event);
    }
  }

  Stream<ReadingListState> _mapReadingListLoadedToState() async* {
    try {
      final books = await this.readingListService.loadReadingList();
      yield ReadingListLoadSuccess(
          // Potentially use the from entity to convert json to typed object
          // books.map(ListedBook.fromEntity).toList(),
          );
    } catch (_) {
      yield ReadingListLoadFailure();
    }
  }

  Stream<ReadingListState> _mapReadingListRefreshedToState() async* {
    try {
      final books = await this.readingListService.loadReadingList();
      yield ReadingListLoadSuccess(
          // Potentially use the from entity to convert json to typed object
          // books.map(ListedBook.fromEntity).toList(),
          );
    } catch (_) {
      yield ReadingListLoadFailure();
    }
  }

  Stream<ReadingListState> _mapReadingListAddedToState(
      ReadingListAdded event) async* {
    if (state is ReadingListLoadSuccess) {
      final List<ListedBook> updatedReadingList =
          List.from((state as ReadingListLoadSuccess).readingList)
            ..add(event.book);
      yield ReadingListLoadSuccess(updatedReadingList);
      _saveReadingList(updatedReadingList);
    }
  }

  Stream<ReadingListState> _mapReadingListUpdatedToState(
      ReadingListUpdated event) async* {
    if (state is ReadingListLoadSuccess) {
      final List<ListedBook> updatedReadingList =
          (state as ReadingListLoadSuccess).readingList.map((book) {
        return book.bookId == event.book.bookId ? event.book : book;
      }).toList();
      yield ReadingListLoadSuccess(updatedReadingList);
      _saveReadingList(updatedReadingList);
    }
  }

  Stream<ReadingListState> _mapReadingListDeletedToState(
      ReadingListDeleted event) async* {
    if (state is ReadingListLoadSuccess) {
      final updatedReadingList = (state as ReadingListLoadSuccess)
          .readingList
          .where((book) => book.bookId != event.book.bookId)
          .toList();
      yield ReadingListLoadSuccess(updatedReadingList);
      _saveReadingList(updatedReadingList);
    }
  }

  Future _saveReadingList(List<ListedBook> readingList) {
    return readingListService.saveReadingList(
        // Use the convert ListBook to json and store it locally
        // readingList.map((todo) => todo.toEntity()).toList(),
        );
  }
}
