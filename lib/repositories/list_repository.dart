import 'dart:convert';
import 'package:lexity_mobile/utils/doubly_linked_list.dart';
import 'package:pedantic/pedantic.dart';
import 'package:uuid/uuid.dart';

import '../extensions/extensions.dart';
import '../models/models.dart';
import '../services/services.dart';

class ListRepository {
  ListService listService = ListService();
  DoublyLinkedList dll = DoublyLinkedList();

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
    return sortByTypeAndInjectHeaders(unindexedReadingList.removeHeaders);
  }

  /// Add a book to the current reading list, updating it if it already exists.
  /// The added book will be synced to the remote db, and the doubly linked list
  /// updated to reflect the inserted book
  List<ListedBook> addBook(
      User user, ListedBook book, List<ListedBook> readingList) {
    List<ListedBook> books;
    // Get index if exists - will return -1 with no match
    final matchingIndex =
        readingList.indexWhere((b) => b.bookId == book.bookId);
    var insertIndex = _getIndexByType(book.type, readingList);

    // >= 0 implies that bookId is already present in the readingList
    if (matchingIndex >= 0) {
      var oldBook = readingList.removeAt(matchingIndex);
      // If the newer position is lower in the list, all tiles will 'slide'
      // up the list, therefore the new index should be decreased by one
      if (insertIndex > matchingIndex) {
        insertIndex -= 1;
      }

      // Combine existing and new recos and notes in ListedBook
      book
        ..addAndDeduplicateRecos = oldBook.recos ?? []
        ..addAllNotes = oldBook.notes ?? []
        ..updatedAt = DateTime.now().millisecondsSinceEpoch;

      books = [book]; // declare, in event below if fnctn generates no books

      // If type is NOT changing, then replace the book in the matchingIndex
      if (book.type == oldBook.type) {
        readingList.insert(matchingIndex, book);
      } else {
        readingList.insert(insertIndex, book);
        books =
            dll.moveExistingBook(user, readingList, matchingIndex, insertIndex);
      }
    } else {
      readingList.insert(insertIndex, book);
      books = dll.addBook(user, readingList, insertIndex);
    }

    // Try and update in the remote database
    try {
      unawaited(listService.addOrUpdateListItem(user, books));
    } catch (err) {
      print('Could not update list type on the backend: $err');
    }

    return readingList;
  }

  /// Update a book in the reading list and when the type value changes,
  /// determine the appropriate new index for the updatedBook, such that it is
  /// located in the correct list location. Changes the list order will also
  /// prompt an update the Doubly Linked List which will update the prev, next
  /// firstNode, and lastNode values as neccessary and handle backend DB sync
  List<ListedBook> updateBook(
      User user, ListedBook updatedBook, List<ListedBook> readingList) {
    List<ListedBook> books;
    final index = readingList.indexWhere((b) => b.bookId == updatedBook.bookId);
    final book = readingList[index];

    // index will be -1 if the book to be updated can't be found in readingList
    if (index >= 0) {
      // if type is the same, then list order doesn't change and updatedBook
      // can simply be inserted into the index of the book
      if (book.type == updatedBook.type) {
        updatedBook.updatedAt = DateTime.now().millisecondsSinceEpoch;
        readingList
          ..removeAt(index)
          ..insert(index, updatedBook);
        return readingList;
      } else {
        // else type is different and list order will change
        var newTypeIndex = _getIndexByType(updatedBook.type, readingList);

        // If the newer position is lower in the list, all tiles will 'slide'
        // up the list, therefore the new index should be decreased by one
        if (newTypeIndex > index) {
          newTypeIndex -= 1;
        }

        updatedBook.updatedAt = DateTime.now().millisecondsSinceEpoch;
        readingList
          ..removeAt(index)
          ..insert(newTypeIndex ?? index, updatedBook);

        // Update the doubly linked list given the list reordering impact
        // caused by the change in updatedBook.type
        books = dll.moveExistingBook(user, readingList, index, newTypeIndex);

        // Try and update in the remote database
        try {
          unawaited(listService.addOrUpdateListItem(user, books));
        } catch (err) {
          print('Could not update list type on the backend: $err');
        }

        return readingList;
      }
    } else {
      print(
          'No matching bookID found to update; returning original ReadingList');
      return readingList;
    }
  }

  /// This is an inflexible, somewhat 'hacky', solution.
  /// Given that the ReadingList is shared between UserScreen and HomeScreen,
  /// we render the HomeScreen and filter (empty container) all type = 'READ'.
  /// An outcome of this is that a drag to the bottom of the "Want to read"
  /// section will have a newIndex at the end of the overall array, because
  /// the newIndex is read as AFTER all of the empty 'READ' containers.
  /// To solve this, isHomescreen bool was created, so that a drag to an index
  /// that is beyond the scope of HomeScreen - that is, an index that would be
  ///  'READ' - will be automatically reassigned to the last acceptable
  /// HomeScreen view index of readingList
  List<ListedBook> reorderBook(List<ListedBook> readingList, int oldIndex,
      int newIndex, User user, bool isHomescreen) {
    List<ListedBook> books;
    if (isHomescreen && newIndex > readingList.lengthWithoutRead) {
      newIndex = readingList.lengthWithoutRead;
    }

    final newIndexType = _getTypeByIndex(
        newIndex, readingList.readingCount, readingList.toReadCount);
    final oldIndexType = _getTypeByIndex(
        oldIndex, readingList.readingCount, readingList.toReadCount);

    // If the newer position is lower in the list, all tiles will 'slide'
    // up the list, therefore the new index should be decreased by one
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final book = readingList.removeAt(oldIndex);
    books = [book]; // declare, in event below if function fails

    if (newIndexType == oldIndexType) {
      readingList.insert(newIndex, book);
      books = dll.moveExistingBook(user, readingList, oldIndex, newIndex);
    } else {
      book.changeType = newIndexType;
      readingList.insert(newIndex, book);
      books = dll.moveExistingBook(user, readingList, oldIndex, newIndex);
    }

    try {
      unawaited(listService.addOrUpdateListItem(user, books));
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

/// Based on the book type, an appropriate index in the readingList will be
/// provided. Types of 'READING' or 'TO_READ' will provide the index at the
/// bottom of those respective type subsections, whereas a 'READ' type will
/// provide the index at the top of the 'READ' subsection.
int _getIndexByType(String newType, List<ListedBook> readingList) {
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
