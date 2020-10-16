import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:pedantic/pedantic.dart';

import '../extensions/extensions.dart';
import '../models/models.dart';
import '../services/services.dart';

class ListRepository {
  ListService get listService => GetIt.I<ListService>();

  Future<List<ListedBook>> loadReadingList(User user) async {
    List<ListedBook> readingList;
    try {
      final list =
          await listService.getListItemSummary(user.accessToken, user.id);
      var decoded = jsonDecode(list.data) as List;
      readingList = decoded.map((book) => ListedBook.fromJson(book)).toList();
    } catch (err) {
      print('Issue loading ReadingList data from backend: $err');
    }
    return readingList;
  }

  saveReadingList() async {}

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

  removeHeaders(List<ListedBook> readingList) {}

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

      // Combine existing and new reco in ListItem book
      book.addAndDeduplicateRecos = oldBook.recos ?? [];

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

  Future<List<ListedBook>> reorderBook(List<ListedBook> readingList,
      int oldIndex, int newIndex, User user, bool isHomescreen) async {
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
    if (isHomescreen && newIndex > readingList.lengthWithoutRead)
      newIndex = readingList.lengthWithoutRead;

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
      unawaited(listService.updateListItemType(
          user.accessToken, user.id, book.bookId, book.type));
    } catch (err) {
      print('Could not update list type on the backend: $err');
    }

    return readingList;
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
        print('My new index is: $newIndex');
        break;
      }
    case 'TO_READ':
      {
        newIndex = readingList.readingCount + readingList.toReadCount;
        break;
      }
    default:
      {
        // Move read books to the top of the READ array
        newIndex = readingList.length - readingList.readCount;
        break;
      }
  }
  return newIndex;
}
