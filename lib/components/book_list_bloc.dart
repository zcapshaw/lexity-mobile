import 'dart:async';
import 'package:rxdart/rxdart.dart';

class BookListBloc {
  final BehaviorSubject<Map<String, int>> _listCountController =
      BehaviorSubject<Map<String, int>>();

  final Map<String, int> _listCountItems = {};

  Stream<Map<String, int>> get listCount => _listCountController.stream;

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
  }
}

final bookListBloc = BookListBloc();
