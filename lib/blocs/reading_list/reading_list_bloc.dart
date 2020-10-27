import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import '../../services/services.dart';

part './reading_list_event.dart';
part './reading_list_state.dart';

class ReadingListBloc extends Bloc<ReadingListEvent, ReadingListState> {
  ReadingListBloc({@required this.listRepository, @required this.listService})
      : super(ReadingListLoadInProgress());

  final ListRepository listRepository;
  final ListService listService;

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
    } else if (event is UpdateBookType) {
      yield* _mapUpdateBookTypeToState(event);
    } else if (event is NoteAdded) {
      yield* _mapNoteAddedToState(event);
    } else if (event is NoteDeleted) {
      yield* _mapNoteDeletedToState(event);
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
      await listService.addOrUpdateListItem(event.user.accessToken, event.book);
    }
  }

  Stream<ReadingListState> _mapReadingListUpdatedToState(
      ReadingListUpdated event) async* {
    if (state is ReadingListLoadSuccess) {
      var typeChange = false;
      var updatedReadingList =
          (state as ReadingListLoadSuccess).readingList.map((book) {
        if (book.bookId == event.updatedBook.bookId) {
          event.updatedBook.updatedAt = DateTime.now().millisecondsSinceEpoch;
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
      await listService.addOrUpdateListItem(
          event.user.accessToken, event.updatedBook);
    }
  }

  Stream<ReadingListState> _mapReadingListReorderedToState(
      ReadingListReordered event) async* {
    if (state is ReadingListLoadSuccess) {
      final updatedReadingList = listRepository.reorderBook(
          List.from((state as ReadingListLoadSuccess).readingList),
          event.oldIndex,
          event.newIndex,
          event.user,
          event.isHomescreen);
      yield ReadingListLoadSuccess(updatedReadingList);
      //TODO: Soon the reorder needs to be saved to local and/or DB
    }
  }

  Stream<ReadingListState> _mapReadingListDeletedToState(
      ReadingListDeleted event) async* {
    if (state is ReadingListLoadSuccess) {
      yield ReadingListUpdating();
      final updatedReadingList = (state as ReadingListLoadSuccess)
          .readingList
          .where((book) => book.bookId != event.book.bookId)
          .toList();
      yield ReadingListLoadSuccess(updatedReadingList);
      await listService.deleteBook(
          event.user.accessToken, event.user.id, event.book.listId);
    }
  }

  Stream<ReadingListState> _mapReadingListDismountToState() async* {
    yield ReadingListLoadInProgress();
  }

  Stream<ReadingListState> _mapUpdateBookTypeToState(
      UpdateBookType event) async* {
    if (state is ReadingListLoadSuccess) {
      yield ReadingListUpdating();
      var updatedReadingList =
          (state as ReadingListLoadSuccess).readingList.map((book) {
        if (book.bookId == event.book.bookId) {
          event.book.updatedAt = DateTime.now().millisecondsSinceEpoch;
          event.book.type = event.newType;
          return event.book;
        } else {
          return book;
        }
      }).toList();
      updatedReadingList = listRepository.updateBookTypeIndex(event.book,
          updatedReadingList, (state as ReadingListLoadSuccess).readingList);
      yield ReadingListLoadSuccess(updatedReadingList);
      await listService.addOrUpdateListItem(event.user.accessToken, event.book);
    }
  }

  Stream<ReadingListState> _mapNoteAddedToState(NoteAdded event) async* {
    try {
      // pass list repo the book and note
      final updatedBook =
          listRepository.addNoteToListedBook(event.note, event.book);
      // add the updated book to the reading list
      var updatedReadingList =
          (state as ReadingListLoadSuccess).readingList.map((book) {
        if (book.bookId == event.book.bookId) {
          return updatedBook;
        } else {
          return book;
        }
      }).toList();
      // yield updated list
      yield ReadingListLoadSuccess(updatedReadingList);
      // update the back end
      await listService.addOrUpdateListItem(
          event.user.accessToken, updatedBook);
    } catch (err) {
      print(err);
      yield ReadingListLoadFailure();
    }
  }

  Stream<ReadingListState> _mapNoteDeletedToState(NoteDeleted event) async* {
    try {
      // delete note
      final updatedBook =
          listRepository.removeNoteFromListedBook(event.noteId, event.book);
      // add the updated book to the reading list
      var updatedReadingList =
          (state as ReadingListLoadSuccess).readingList.map((book) {
        if (book.bookId == event.book.bookId) {
          return updatedBook;
        } else {
          return book;
        }
      }).toList();
      // yield updated list
      yield ReadingListLoadSuccess(updatedReadingList);
      // update the back end
      await listService.addOrUpdateListItem(
          event.user.accessToken, updatedBook);
    } catch (err) {
      print(err);
      yield ReadingListLoadFailure();
    }
  }
}
