import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'list_service.dart';
import '../models/models.dart';
import '../extensions/extensions.dart';

class ReadingListService {
  ListService get listService => GetIt.I<ListService>();

  // TODO: IMPORTANT - Using DotEnv until we can connect reading_list_bloc to the new user_bloc - this needs to be updated to be dynamic once the user_bloc is built
  final String accessToken = DotEnv().env['ACCESS_TOKEN'];
  final String userId = DotEnv().env['USER_ID'];

  loadReadingList() async {
    return await listService.getListItemSummary(accessToken, userId);
  }

  saveReadingList() async {}

  sortByTypeAndInjectHeaders(List<ListedBook> readingList) {
    List<ListedBook> sortedReadingListWithHeaders = [];
    final List<String> typeSortOrder = ['READING', 'TO_READ', 'READ'];

    typeSortOrder.forEach((type) {
      List<ListedBook> readingListByType =
          readingList.where((book) => book.type == type).toList();
      sortedReadingListWithHeaders.add(ListedBookHeader(type));
      sortedReadingListWithHeaders.addAll(readingListByType);
    });

    return sortedReadingListWithHeaders;
  }

  removeHeaders(List<ListedBook> readingList) {}

  updateBookTypeIndex(ListedBook updatedBook, List<ListedBook> readingList) {
    final int oldIndex =
        readingList.indexWhere((b) => b.bookId == updatedBook.bookId);

    // oldIndex returns -1 if no matching bookId is found
    if (oldIndex > 0) {
      int newIndex = _getTypeChangeIndex(updatedBook.type, readingList);

      // // If the newer position is lower in the list, all tiles will 'slide'
      // // up the list, therefore the new index should be decreased by one
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      readingList.removeAt(oldIndex);
      readingList.insert(newIndex ?? oldIndex, updatedBook);
      return readingList;
    } else {
      print(
          'Could not find matching bookID to update - returning original ReadingList');
      return readingList;
    }
  }

  reorderBook(List<ListedBook> readingList, int oldIndex, int newIndex,
      bool isHomescreen) async {
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

    String newIndexType = _getTypeByIndex(
        newIndex, readingList.readingCount, readingList.toReadCount);
    String oldIndexType = _getTypeByIndex(
        oldIndex, readingList.readingCount, readingList.toReadCount);

    // // If the newer position is lower in the list, all tiles will 'slide'
    // // up the list, therefore the new index should be decreased by one
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final ListedBook book = readingList.removeAt(oldIndex);

    if (newIndexType == oldIndexType) {
      readingList.insert(newIndex, book);
    } else {
      book.changeType = newIndexType;
      readingList.insert(newIndex, book);
    }

    try {
      // TODO: Remove DotEnv fixed variables once User Provider is loaded
      listService.updateListItemType(
          accessToken, userId, book.bookId, book.type);
    } catch (err) {
      print('Could not update list type on the backend: $err');
    }

    return readingList;
  }

  void addOrUpdateBook(ListedBook book) async {
    try {
      await listService.addOrUpdateListItem(accessToken, book);
    } catch (err) {
      print('Could not add or update the book in the backend: $err');
    }
  }

  void deleteBook(ListedBook book) async {
    try {
      await listService.deleteBook(accessToken, userId, book.listId);
    } catch (err) {
      print('Could not delete the book in the backend: $err');
    }
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
        newIndex = readingList.readingCountExcludingHeader;
        print('My new index is: $newIndex');
        break;
      }
    case 'TO_READ':
      {
        newIndex = readingList.readingCountExcludingHeader +
            readingList.toReadCountExcludingHeader;
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
