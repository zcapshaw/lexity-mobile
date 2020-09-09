import 'dart:async';
import 'dart:convert';
import 'package:lexity_mobile/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';

import '../services/list_service.dart';
import '../models/list_item.dart';

class BookListBloc {
  ListService get listService => GetIt.I<ListService>();
  final BehaviorSubject<Map<String, int>> _listCountController =
      BehaviorSubject<Map<String, int>>();
  final BehaviorSubject<List<ListItem>> _listBookController =
      BehaviorSubject<List<ListItem>>();

  final Map<String, int> _listCountItems = {};

  Stream<Map<String, int>> get listCount => _listCountController.stream;
  Stream<List<ListItem>> get listBooks => _listBookController.stream;

  Future<void> refreshBackendBookList(String accessToken, String userId) async {
    final response = await listService.getListItemSummary(accessToken, userId);
    if (!response.error) {
      var bookJson = jsonDecode(response.data);
      if (!_listBookController.isClosed) {
        List<ListItem> readingList = [];

        // Update list counts based on backend array lengths
        int readingCount = bookJson['READING'].length;
        int toReadCount = bookJson['TO_READ'].length;
        int readCount = bookJson['READ'].length;
        addListCountItem('READING', readingCount);
        addListCountItem('TO_READ', toReadCount);
        addListCountItem('READ', readCount);

        // Create ListItems fromJson and add to readingList
        readingList.add(ListItemHeader('READING'));
        for (var item in bookJson['READING']) {
          var book = ListItem.fromJson(item);
          readingList.add(book);
        }
        readingList.add(ListItemHeader('TO_READ'));
        for (var item in bookJson['TO_READ']) {
          var book = ListItem.fromJson(item);
          readingList.add(book);
        }
        readingList.add(ListItemHeader('READ'));
        for (var item in bookJson['READ']) {
          var book = ListItem.fromJson(item);
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

  void reorderBook(User user, int oldIndex, int newIndex) {
    String newIndexType = _getTypeByIndex(newIndex);
    String oldIndexType = _getTypeByIndex(oldIndex);
    if (!_listBookController.isClosed) {
      // If the newer position is lower in the list, all tiles will 'slide'
      // up the list, therefore the new index should be decreased by one
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      final readingList = _listBookController.value;
      final ListItem book = readingList.removeAt(oldIndex);
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
              user.accessToken, user.id, book.id, newIndexType);
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

  void changeBookType(ListItem book, User user, int oldIndex, String newType) {
    final readingList = _listBookController.value;
    final String prevType = book.bookType;
    final ListItem item = readingList.removeAt(oldIndex);
    item.changeType = newType;
    readingList.insert(_getTypeChangeIndex(newType), item);
    _listBookController.sink.add(readingList);
    _typeChangeCounter(newType, prevType);
    try {
      listService.updateListItemType(
          user.accessToken, user.id, book.id, newType);
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
          newIndex = readingListLength;
          break;
        }
    }
    return newIndex;
  }

  void deleteBook(ListItem book, User user) {
    final readingList = _listBookController.value;
    readingList.remove(book);
    _listBookController.sink.add(readingList);
    // reduce associated type counter by 1
    addListCountItem(book.bookType, --_listCountItems[book.bookType]);
    try {
      listService.deleteBook(user.accessToken, user.id, book.bookListId);
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
