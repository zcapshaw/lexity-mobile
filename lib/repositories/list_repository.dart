import 'dart:convert';
import 'package:pedantic/pedantic.dart';
import 'package:uuid/uuid.dart';

import '../extensions/extensions.dart';
import '../models/models.dart';
import '../services/services.dart';

class ListRepository {
  ListService listService = ListService();

  Future<List<ListedBook>> loadReadingList(User user) async {
    List<ListedBook> readingList;
    try {
      final list =
          await listService.getListItemSummary(user.accessToken, user.id);
      final decoded = jsonDecode(list.data as String) as List;
      readingList = decoded
          .map((dynamic book) =>
              ListedBook.fromJson(book as Map<String, dynamic>))
          .toList();
    } catch (err) {
      print('Issue loading ReadingList data from backend: $err');
    }
    return readingList;
  }

  List<ListedBook> sortByTypeAndInjectHeaders(List<ListedBook> readingList) {
    // ignore: omit_local_variable_types
    List<ListedBook> sortedReadingListWithHeaders = [];
    final typeSortOrder = ['READING', 'TO_READ', 'READ'];

    for (var type in typeSortOrder) {
      var readingListByType =
          readingList.where((book) => book.type == type).toList();
      sortedReadingListWithHeaders
        ..add(ListedBookHeader(type))
        ..addAll(readingListByType);
    }

    return sortedReadingListWithHeaders;
  }

  List<ListedBook> reindexListWithHeaders(
      List<ListedBook> unindexedReadingList) {
    return sortByTypeAndInjectHeaders(_removeHeaders(unindexedReadingList));
  }

  List<ListedBook> _removeHeaders(List<ListedBook> readingListWithHeaders) {
    var readingListWithoutHeaders = readingListWithHeaders
      ..removeWhere((book) => book.runtimeType == ListedBookHeader);
    return readingListWithoutHeaders;
  }

  List<ListedBook> addBook(ListedBook book, List<ListedBook> readingList) {
    // Get index if exists - will return -1 with no match
    final matchingIndex =
        readingList.indexWhere((b) => b.bookId == book.bookId);
    var insertIndex = _getTypeChangeIndex(book.type, readingList);

    // >= 0 implies that bookId is already present in the readingList
    if (matchingIndex >= 0) {
      var oldBook = readingList.removeAt(matchingIndex);
      if (insertIndex > matchingIndex) {
        insertIndex -= 1;
      }

      // Combine existing and new recos and notes in ListedBook
      book
        ..addAndDeduplicateRecos = oldBook.recos ?? []
        ..addAllNotes = oldBook.notes ?? []
        ..updatedAt = DateTime.now().millisecondsSinceEpoch;

      // If type is NOT changing, then replace the book in the matchingIndex
      if (book.type == oldBook.type) {
        readingList.insert(matchingIndex, book);
      } else {
        readingList.insert(insertIndex, book);
      }
    } else {
      readingList.insert(insertIndex, book);
    }
    return readingList;
  }

  List<ListedBook> updateBookTypeIndex(ListedBook updatedBook,
      List<ListedBook> newReadingList, List<ListedBook> prevReadingList) {
    final oldIndex =
        newReadingList.indexWhere((b) => b.bookId == updatedBook.bookId);

    if (oldIndex > 0) {
      var newIndex = _getTypeChangeIndex(updatedBook.type, prevReadingList);

      // // If the newer position is lower in the list, all tiles will 'slide'
      // // up the list, therefore the new index should be decreased by one
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      newReadingList
        ..removeAt(oldIndex)
        ..insert(newIndex ?? oldIndex, updatedBook);
      return newReadingList;
    } else {
      print(
          'No matching bookID found to update; returning original ReadingList');
      return newReadingList;
    }
  }

  List<ListedBook> reorderBook(List<ListedBook> readingList, int oldIndex,
      int newIndex, User user, bool isHomescreen) {
    //final ReadingListIndexes listIndexes = ReadingListIndexes(readingList);

    // // This is an inflexible, somewhat 'hacky', solution.
    // // Given that the List BLoC is shared between the UserScreen and HomeScreen
    // // We render the HomeScreen and filter out (empty containers) all type = 'READ'
    // // An outcome of this, is that a drag to the bottom of the "Want to read"
    // // section will have a newIndex at the end of the overall array, because
    // // the newIndex is read as AFTER all of the empty 'READ' containers.
    // // To solve this, isHomescreen bool was created, so that a drag to an index that is
    // // beyond the scope of HomeScreen - that is, an index that would be 'READ' - will be
    // // automatically reassigned to the last acceptable HomeScreen view index of readingList
    if (isHomescreen && newIndex > readingList.lengthWithoutRead) {
      newIndex = readingList.lengthWithoutRead;
    }

    final newIndexType = _getTypeByIndex(
        newIndex, readingList.readingCount, readingList.toReadCount);
    final oldIndexType = _getTypeByIndex(
        oldIndex, readingList.readingCount, readingList.toReadCount);

    // // If the newer position is lower in the list, all tiles will 'slide'
    // // up the list, therefore the new index should be decreased by one
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final book = readingList.removeAt(oldIndex);

    if (newIndexType == oldIndexType) {
      readingList.insert(newIndex, book);
    } else {
      book.changeType = newIndexType;
      readingList.insert(newIndex, book);
    }

    try {
      unawaited(listService.addOrUpdateListItem(user.accessToken, book));
    } catch (err) {
      print('Could not update list type on the backend: $err');
    }

    return readingList;
  }

  ListedBook addNoteToListedBook(String noteText, ListedBook book) {
    // construct a Note object from the text passed from the UI
    final note = Note(
      id: Uuid().v4(),
      comment: noteText,
      created: DateTime.now().millisecondsSinceEpoch,
    );

    // insert note as first element in notes list
    book.notes.insert(0, note);

    // set the updated at timestamp
    book.updatedAt = DateTime.now().millisecondsSinceEpoch;

    // return updated ListedBook object
    return book;
  }

  ListedBook removeNoteFromListedBook(String noteId, ListedBook book) {
    // remove note by ID and set updated timestamp
    var newBook = book.clone();
    var updatedNotes = List<Note>.from(book.notes)
      ..removeWhere((note) => note.id == noteId);
    newBook
      ..notes = updatedNotes
      ..updatedAt = DateTime.now().millisecondsSinceEpoch;

    // return updated ListedBook object
    return newBook;
  }

  ListedBook updateNoteForListedBook(
      String noteId, ListedBook book, String newText) {
    // update note text
    var updatedNotes = book.notes.map((note) {
      if (note.id == noteId) {
        note.comment = newText;
        return note;
      } else {
        return note;
      }
    }).toList();

    book.notes = updatedNotes;

    return book;
  }

  String _getTypeByIndex(int index, int readingCount, int toReadCount) {
    String type;

    if (index <= readingCount) {
      type = 'READING';
    } else if (index <= readingCount + toReadCount) {
      type = 'TO_READ';
    } else {
      type = 'READ';
    }
    return type;
  }
}

int _getTypeChangeIndex(String newType, List<ListedBook> readingList) {
  int newIndex;
  switch (newType) {
    case 'READING':
      {
        newIndex = readingList.readingCount;
      }
      break;
    case 'TO_READ':
      {
        newIndex = readingList.readingCount + readingList.toReadCount;
      }
      break;
    default:
      {
        // Move read books to the top of the READ array
        newIndex = readingList.lengthWithoutReadPlusHeader;
      }
      break;
  }
  return newIndex;
}
