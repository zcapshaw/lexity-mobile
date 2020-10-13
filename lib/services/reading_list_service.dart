import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'list_service.dart';
import '../models/models.dart';

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

  reorderBook(List<ListedBook> readingList, int oldIndex, int newIndex,
      bool isHomescreen) async {
    final ReadingListIndexes listIndexes = ReadingListIndexes(readingList);

    // // This is an inflexible, somewhat 'hacky', solution.
    // // Given that the List BLoC is shared between the UserScreen and HomeScreen
    // // We render the HomeScreen and filter out (empty containers) all type = 'READ'
    // // An outcome of this, is that a drag to the bottom of the "Want to read"
    // // section will have a newIndex at the end of the overall array, because
    // // the newIndex is read as AFTER all of the empty 'READ' containers.
    // // To solve this, isHomescreen bool was created, so that a drag to an index that is
    // // beyond the scope of HomeScreen - that is, an index that would be 'READ' - will be
    // // automatically reassigned to the last acceptable HomeScreen view index of readingList
    if (isHomescreen && newIndex > listIndexes.lengthWithoutRead)
      newIndex = listIndexes.lengthWithoutRead;

    String newIndexType = _getTypeByIndex(
        newIndex, listIndexes.readingCount, listIndexes.toReadCount);
    String oldIndexType = _getTypeByIndex(
        oldIndex, listIndexes.readingCount, listIndexes.toReadCount);

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

class ReadingListIndexes {
  final List<ListedBook> readingList;
  final int headerPlaceholder = 1;

  ReadingListIndexes(this.readingList);

  int get readingCount {
    return readingList.where((book) => book.reading).toList().length;
  }

  int get toReadCount {
    return readingList.where((book) => book.toRead).toList().length;
  }

  int get readCount {
    return readingList.where((book) => book.read).toList().length;
  }

  int get lengthWithoutRead {
    return readingList.length - this.readCount;
  }

  int get listLength => readingList.length;
}
