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
    print(
        'newIndex: $newIndex, lengthWithoutRead: ${listIndexes.lengthWithoutRead}');
    if (isHomescreen && newIndex > listIndexes.lengthWithoutRead)
      newIndex = listIndexes.lengthWithoutRead;

    print('newnewindex: $newIndex');
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
    // String newBookType;

    // Capture appropriate new type based off of prior ListedBook.type at newIndex
    // If class is ListedBookHeader further reference up/down the list
    // if (readingList[newIndex] is ListedBookHeader) {
    //   newBookType = readingList[newIndex + 1].type;
    // } else if (readingList[newIndex] is ListedBookHeader &&
    //     newIndex < oldIndex) {
    //   newBookType = readingList[newIndex - 1].type;
    // } else {
    //   newBookType = readingList[newIndex].type;
    // }

    // print('bookType: ${book.type}, newBookType: $newBookType');
    // book.changeType = newBookType;
    // readingList.insert(newIndex, book);
    if (newIndexType == oldIndexType) {
      print('Same type ${book.title}');
      readingList.insert(newIndex, book);
    } else {
      print('Different type ${book.title}');
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

    // print(
    //     'Again, check title at new index ${updatedReadingList[newIndex].title}');
    return readingList;
  }

  // void reorderBook(int oldIndex, int newIndex, bool isHomescreen) {
  //   final int headerPlaceholder = 1;
  //   final readingList = _listBookController.value;
  //   final int readingListLength = readingList.length;
  //   final int lengthWithoutRead =
  //       readingListLength - _listCountItems['READ'] - headerPlaceholder;

  //   // This is an inflexible, somewhat 'hacky', solution.
  //   // Given that the List BLoC is shared between the UserScreen and HomeScreen
  //   // We render the HomeScreen and filter out (empty containers) all type = 'READ'
  //   // An outcome of this, is that a drag to the bottom of the "Want to read"
  //   // section will have a newIndex at the end of the overall array, because
  //   // the newIndex is read as AFTER all of the empty 'READ' containers.
  //   // To solve this, isHomescreen bool was created, so that a drag to an index that is
  //   // beyond the scope of HomeScreen - that is, an index that would be 'READ' - will be
  //   // automatically reassigned to the last acceptable HomeScreen view index of readingList
  //   if (isHomescreen && newIndex > lengthWithoutRead)
  //     newIndex = lengthWithoutRead;

  //   String newIndexType = _getTypeByIndex(newIndex);
  //   String oldIndexType = _getTypeByIndex(oldIndex);
  //   if (!_listBookController.isClosed) {
  //     // If the newer position is lower in the list, all tiles will 'slide'
  //     // up the list, therefore the new index should be decreased by one
  //     if (newIndex > oldIndex) {
  //       newIndex -= 1;
  //     }

  //     final ListedBook book = readingList.removeAt(oldIndex);
  //     if (newIndexType == oldIndexType) {
  //       readingList.insert(newIndex, book);
  //       _listBookController.sink.add(readingList);
  //     } else {
  //       book.changeType = newIndexType;
  //       _typeChangeCounter(newIndexType, oldIndexType);
  //       readingList.insert(newIndex, book);
  //       _listBookController.sink.add(readingList);
  //       try {
  //         listService.updateListItemType(
  //             user.accessToken, user.id, book.bookId, newIndexType);
  //       } catch (err) {
  //         print('Could not update list type on the backend: $err');
  //       }
  //     }
  //   }
  // }

  // Determine the appropriate type based off of the index
  // NOTE: This assumes a consistant array structure order of types
  // ['READING', 'TO_READ', 'READ']
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
