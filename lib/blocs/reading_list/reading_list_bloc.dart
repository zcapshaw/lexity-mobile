import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:lexity_mobile/extensions/reading_list.dart';
import 'package:meta/meta.dart';
import 'package:lexity_mobile/blocs/reading_list/reading_list.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:lexity_mobile/services/reading_list_service.dart';
import 'package:lexity_mobile/extensions/extensions.dart';

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
    } else if (event is ReadingListReordered) {
      yield* _mapReadingListReorderedToState(event);
    } else if (event is ReadingListDeleted) {
      yield* _mapReadingListDeletedToState(event);
    }
  }

  Stream<ReadingListState> _mapReadingListLoadedToState() async* {
    try {
      final list = await this.readingListService.loadReadingList();
      var decodedList = jsonDecode(list.data) as List;
      List<ListedBook> readingList =
          decodedList.map((book) => ListedBook.fromJson(book)).toList();
      yield ReadingListLoadSuccess(
          readingListService.sortByTypeAndInjectHeaders(readingList));
    } catch (err) {
      print(err);
      yield ReadingListLoadFailure();
    }
  }

  // Same action as _mapReadingListLoadedToState, but unique event driver of ReadingListRefreshed
  Stream<ReadingListState> _mapReadingListRefreshedToState() async* {
    try {
      final list = await this.readingListService.loadReadingList();
      var decodedList = jsonDecode(list.data) as List;
      List<ListedBook> readingList =
          decodedList.map((book) => ListedBook.fromJson(book)).toList();
      yield ReadingListLoadSuccess(
          readingListService.sortByTypeAndInjectHeaders(readingList));
    } catch (err) {
      print(err);
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
      bool typeChange = false;
      List<ListedBook> updatedReadingList =
          (state as ReadingListLoadSuccess).readingList.map((book) {
        if (book.bookId == event.updatedBook.bookId) {
          typeChange = book.type != event.updatedBook.type ? true : false;
          return event.updatedBook;
        } else {
          return book;
        }
      }).toList();
      if (typeChange) {
        updatedReadingList = await readingListService.updateBookTypeIndex(
          event.updatedBook,
          updatedReadingList,
        );
      }
      yield ReadingListLoadSuccess(updatedReadingList);
      readingListService.addOrUpdateBook(event.updatedBook);
    }
  }

  Stream<ReadingListState> _mapReadingListReorderedToState(
      ReadingListReordered event) async* {
    if (state is ReadingListLoadSuccess) {
      List<ListedBook> updatedReadingList =
          await readingListService.reorderBook(
              List.from((state as ReadingListLoadSuccess).readingList),
              event.oldIndex,
              event.newIndex,
              event.isHomescreen);
      yield ReadingListLoadSuccess(updatedReadingList);
      //TODO: Soon the reorder needs to be saved to local and/or DB
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
      readingListService.deleteBook(event.book);
    }
  }

  Future _saveReadingList(List<ListedBook> readingList) {
    return readingListService.saveReadingList(
        // Use the convert ListBook to json and store it locally
        // readingList.map((todo) => todo.toEntity()).toList(),
        );
  }
}
