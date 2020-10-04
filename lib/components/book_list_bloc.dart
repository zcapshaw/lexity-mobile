import 'dart:async';
import 'dart:convert';
import 'package:lexity_mobile/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';

import '../services/list_service.dart';
import '../models/listed_book.dart';

class BookListBloc {
  ListService get listService => GetIt.I<ListService>();
  final BehaviorSubject<Map<String, int>> _listCountController =
      BehaviorSubject<Map<String, int>>();
  final BehaviorSubject<List<ListedBook>> _listBookController =
      BehaviorSubject<List<ListedBook>>();

  final Map<String, int> _listCountItems = {};

  Stream<Map<String, int>> get listCount => _listCountController.stream;
  Stream<List<ListedBook>> get listBooks => _listBookController.stream;

  Future<void> refreshBackendBookList(String accessToken, String userId) async {
    final response = await listService.getListItemSummary(accessToken, userId);
    if (!response.error) {
      var bookJson = jsonDecode(response.data);
      if (!_listBookController.isClosed) {
        List<ListedBook> readingList = [];

        // Update list counts based on backend array lengths
        int readingCount = bookJson['READING'].length;
        int toReadCount = bookJson['TO_READ'].length;
        int readCount = bookJson['READ'].length;
        addListCountItem('READING', readingCount);
        addListCountItem('TO_READ', toReadCount);
        addListCountItem('READ', readCount);

        // Create ListedBooks fromJson and add to readingList
        readingList.add(ListItemHeader('READING'));
        for (var item in bookJson['READING']) {
          var book = ListedBook.fromJson(item);
          readingList.add(book);
        }
        readingList.add(ListItemHeader('TO_READ'));
        for (var item in bookJson['TO_READ']) {
          var book = ListedBook.fromJson(item);
          readingList.add(book);
        }
        readingList.add(ListItemHeader('READ'));
        for (var item in bookJson['READ']) {
          var book = ListedBook.fromJson(item);
          readingList.add(book);
        }

        // Add the new readingList to the BLoC
        _listBookController.sink.add(readingList);
      } else {
        print(response.errorCode);
        print(response.errorMessage);
      }
    }
  }

  void reorderBook(User user, int oldIndex, int newIndex, bool isHomescreen) {
    final int headerPlaceholder = 1;
    final readingList = _listBookController.value;
    final int readingListLength = readingList.length;
    final int lengthWithoutRead =
        readingListLength - _listCountItems['READ'] - headerPlaceholder;

    // This is an inflexible, somewhat 'hacky', solution.
    // Given that the List BLoC is shared between the UserScreen and HomeScreen
    // We render the HomeScreen and filter out (empty containers) all type = 'READ'
    // An outcome of this, is that a drag to the bottom of the "Want to read"
    // section will have a newIndex at the end of the overall array, because
    // the newIndex is read as AFTER all of the empty 'READ' containers.
    // To solve this, isHomescreen bool was created, so that a drag to an index that is
    // beyond the scope of HomeScreen - that is, an index that would be 'READ' - will be
    // automatically reassigned to the last acceptable HomeScreen view index of readingList
    if (isHomescreen && newIndex > lengthWithoutRead)
      newIndex = lengthWithoutRead;

    String newIndexType = _getTypeByIndex(newIndex);
    String oldIndexType = _getTypeByIndex(oldIndex);
    if (!_listBookController.isClosed) {
      // If the newer position is lower in the list, all tiles will 'slide'
      // up the list, therefore the new index should be decreased by one
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      final ListedBook book = readingList.removeAt(oldIndex);
      if (newIndexType == oldIndexType) {
        readingList.insert(newIndex, book);
        _listBookController.sink.add(readingList);
      } else {
        book.changeType = newIndexType;
        _typeChangeCounter(newIndexType, oldIndexType);
        readingList.insert(newIndex, book);
        _listBookController.sink.add(readingList);
        try {
          listService.updateListItemType(
              user.accessToken, user.id, book.bookId, newIndexType);
        } catch (err) {
          print('Could not update list type on the backend: $err');
        }
      }
    }
  }

  // Determine the appropriate type based off of the index
  // NOTE: This assumes a consistant array structure order of types
  // ['READING', 'TO_READ', 'READ']
  String _getTypeByIndex(int index) {
    final int headerPlaceholder = 1;
    final int readingCount = _listCountItems['READING'];
    final int toReadCount = _listCountItems['TO_READ'];
    String type;

    if (index <= readingCount + headerPlaceholder) {
      type = 'READING';
    } else if (index <= readingCount + toReadCount + (headerPlaceholder * 2)) {
      type = 'TO_READ';
    } else {
      type = 'READ';
    }
    return type;
  }

  void _typeChangeCounter(String newType, String prevType) {
    // Update counters for dynamic header counts
    addListCountItem(newType, ++_listCountItems[newType]);
    addListCountItem(prevType, --_listCountItems[prevType]);
  }

  void changeBookType(
      ListedBook book, User user, int oldIndex, String newType) {
    final readingList = _listBookController.value;
    final String prevType = book.type;
    final ListedBook item = readingList.removeAt(oldIndex);
    item.changeType = newType;
    readingList.insert(_getTypeChangeIndex(newType), item);
    _listBookController.sink.add(readingList);
    _typeChangeCounter(newType, prevType);
    try {
      listService.updateListItemType(
          user.accessToken, user.id, book.bookId, newType);
    } catch (err) {
      print('Could not update list type on the backend: $err');
    }
  }

  int _getTypeChangeIndex(String newType) {
    final int headerPlaceholder = 1;
    final readingListLength = _listBookController.value.length;
    int newIndex;
    switch (newType) {
      case 'READING':
        {
          newIndex = _listCountItems['READING'] + (headerPlaceholder * 1);
          break;
        }
      case 'TO_READ':
        {
          newIndex = _listCountItems['READING'] +
              _listCountItems['TO_READ'] +
              (headerPlaceholder * 2);
          break;
        }
      default:
        {
          // Move read books to the top of the READ array
          newIndex = readingListLength - _listCountItems['READ'];
          break;
        }
    }
    return newIndex;
  }

  void addBook(ListedBook list, ListedBook book, String accessToken) {
    final readingList = _listBookController.value;
    final int matchingIndex = _getIndexIfExists(book.bookId);
    int insertIndex = _getTypeChangeIndex(book.type);

    if (matchingIndex >= 0) {
      ListedBook oldBook = readingList.removeAt(matchingIndex);
      if (insertIndex > matchingIndex) {
        insertIndex -= 1;
      }

      // Combine existing and new reco in ListItem book
      book.mergeRecos = oldBook.recos ?? [];

      // If type is NOT changing, then replace the book in the matchingIndex
      if (book.type == oldBook.type) {
        readingList.insert(matchingIndex, book);
      } else {
        readingList.insert(insertIndex, book);
      }

      // decrease associated type counter by 1
      addListCountItem(oldBook.type, --_listCountItems[oldBook.type]);
    } else {
      readingList.insert(insertIndex, book);
    }
    _listBookController.sink.add(readingList);

    // increase associated type counter by 1
    addListCountItem(book.type, ++_listCountItems[book.type]);

    try {
      listService.addOrUpdateListItem(accessToken, list);
    } catch (err) {
      print('Could not add the book in the backend: $err');
    }
  }

  int _getIndexIfExists(String bookId) {
    final readingList = _listBookController.value;
    List bookIdList = [];
    readingList.forEach((e) => bookIdList.add(e.bookId ?? 'HEADER'));
    return bookIdList.indexOf(bookId); // returns -1 if element is not found
  }

  void deleteBook(ListedBook book, User user) {
    final readingList = _listBookController.value;
    readingList.remove(book);
    _listBookController.sink.add(readingList);
    // reduce associated type counter by 1
    addListCountItem(book.type, --_listCountItems[book.type]);
    try {
      listService.deleteBook(user.accessToken, user.id, book.listId);
    } catch (err) {
      print('Could not delete the book in the backend: $err');
    }
  }

  void addListCountItem(String type, int count) {
    if (!_listCountController.isClosed) {
      _listCountItems[type] = count;
      _listCountController.sink.add(_listCountItems);
    }
  }

  void removeListCountItem(String type) {
    if (!_listCountController.isClosed) {
      _listCountItems.keys
          .where((k) => _listCountItems[k].toString() == type)
          .forEach(_listCountItems.remove);
      _listCountController.sink.add(_listCountItems);
    }
  }

  void dispose() {
    _listCountController.close();
    _listBookController.close();
  }
}

final bookListBloc = BookListBloc();
