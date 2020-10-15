import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../repositories/list_repository.dart';
import '../blocs.dart';

class ReadingListBloc extends Bloc<ReadingListEvent, ReadingListState> {
  ReadingListBloc({@required this.listRepository})
      : super(ReadingListLoadInProgress());

  final ListRepository listRepository;

  @override
  Stream<ReadingListState> mapEventToState(ReadingListEvent event) async* {
    if (event is ReadingListLoaded) {
      yield* _mapReadingListLoadedToState(event);
    } else if (event is ReadingListRefreshed) {
      yield* _mapReadingListRefreshedToState(event);
    } else if (event is ReadingListAdded) {
      yield* _mapReadingListAddedToState(event);
    } else if (event is ReadingListUpdated) {
      yield* _mapReadingListUpdatedToState(event);
    } else if (event is ReadingListReordered) {
      yield* _mapReadingListReorderedToState(event);
    } else if (event is ReadingListDeleted) {
      yield* _mapReadingListDeletedToState(event);
    } else if (event is ReadingListDismount) {
      yield* _mapReadingListDismountToState();
    }
  }

  Stream<ReadingListState> _mapReadingListLoadedToState(
      ReadingListLoaded event) async* {
    try {
      var readingList = await listRepository.loadReadingList(event.user);
      yield ReadingListLoadSuccess(
          listRepository.sortByTypeAndInjectHeaders(readingList));
    } catch (err) {
      print(err);
      yield ReadingListLoadFailure();
    }
  }

  Stream<ReadingListState> _mapReadingListRefreshedToState(
      ReadingListRefreshed event) async* {
    try {
      var readingList = await listRepository.loadReadingList(event.user);
      yield ReadingListLoadSuccess(
          listRepository.sortByTypeAndInjectHeaders(readingList));
    } catch (err) {
      print(err);
      yield ReadingListLoadFailure();
    }
  }

  Stream<ReadingListState> _mapReadingListAddedToState(
      ReadingListAdded event) async* {
    if (state is ReadingListLoadSuccess) {
      final updatedReadingList = listRepository.addBook(
          event.book, List.from((state as ReadingListLoadSuccess).readingList));
      yield ReadingListLoadSuccess(updatedReadingList);
      listRepository.addOrUpdateBook(event.book);
    }
  }

  Stream<ReadingListState> _mapReadingListUpdatedToState(
      ReadingListUpdated event) async* {
    if (state is ReadingListLoadSuccess) {
      var typeChange = false;
      var updatedReadingList =
          (state as ReadingListLoadSuccess).readingList.map((book) {
        if (book.bookId == event.updatedBook.bookId) {
          typeChange = book.type != event.updatedBook.type ? true : false;
          return event.updatedBook;
        } else {
          return book;
        }
      }).toList();
      if (typeChange) {
        updatedReadingList = listRepository.updateBookTypeIndex(
            event.updatedBook,
            updatedReadingList,
            (state as ReadingListLoadSuccess).readingList);
      }
      yield ReadingListLoadSuccess(updatedReadingList);
      listRepository.addOrUpdateBook(event.updatedBook);
    }
  }

  Stream<ReadingListState> _mapReadingListReorderedToState(
      ReadingListReordered event) async* {
    if (state is ReadingListLoadSuccess) {
      final updatedReadingList = await listRepository.reorderBook(
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
      listRepository.deleteBook(event.book);
    }
  }

  Stream<ReadingListState> _mapReadingListDismountToState() async* {
    yield ReadingListLoadInProgress();
  }
}
