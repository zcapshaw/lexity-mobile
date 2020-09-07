import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';

import '../services/list_service.dart';
import '../models/reading_list_item.dart';

class BookListBloc {
  ListService get listService => GetIt.I<ListService>();
  final BehaviorSubject<Map<String, int>> _listCountController =
      BehaviorSubject<Map<String, int>>();
  final BehaviorSubject<List<ReadingListItem>> _listBookController =
      BehaviorSubject<List<ReadingListItem>>();

  final Map<String, int> _listCountItems = {};

  Stream<Map<String, int>> get listCount => _listCountController.stream;
  Stream<List<ReadingListItem>> get listBooks => _listBookController.stream;

  Future<void> refreshBackendBookList(String accessToken, String userId) async {
    final response = await listService.getListItemSummary(accessToken, userId);
    if (!response.error) {
      var bookJson = jsonDecode(response.data);
      /*** UGLY Temporary Subsection due to current backend object shape ***/
      List<ReadingListItem> readingList = [];
      List tempBookData = [];
      for (var item in bookJson['TO_READ']) {
        tempBookData.add(item);
      }
      for (var item in bookJson['READING']) {
        tempBookData.add(item);
      }
      for (var item in bookJson['READ']) {
        tempBookData.add(item);
      }
      addListCountItem('TO_READ', bookJson['TO_READ'].length);
      addListCountItem('READING', bookJson['READING'].length);
      addListCountItem('READ', bookJson['READ'].length);

      /*** -------------- ***/
      if (!_listBookController.isClosed) {
        for (var b in tempBookData) {
          String title = b['title'];
          if (b['subtitle'] != null) title = '$title: ${b['subtitle']}';
          BookItem book = BookItem(title, b['authors'][0], b['cover'],
              b['listId'], b['bookId'], b['type'], b['recos']);
          readingList.add(book);
        }
        _listBookController.sink.add(readingList);
      } else {
        print(response.errorCode);
        print(response.errorMessage);
      }
    }
  }

  void reorderBook(int oldIndex, int newIndex) {
    if (!_listBookController.isClosed) {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final readingList = _listBookController.value;
      final ReadingListItem item = readingList.removeAt(oldIndex);
      readingList.insert(newIndex, item);
      _listBookController.sink.add(readingList);
    }
  }

  void deleteBook(
      BookItem book, String accessToken, String userId, String listId) {
    final readingList = _listBookController.value;
    readingList.remove(book);
    _listBookController.sink.add(readingList);
    // reduce associated type counter by 1
    addListCountItem(book.bookType, --_listCountItems[book.bookType]);
    try {
      listService.deleteBook(accessToken, userId, listId);
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
