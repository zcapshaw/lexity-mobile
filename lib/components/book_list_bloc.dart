import 'dart:async';
import 'package:rxdart/rxdart.dart';

class BookListBloc {
  final BehaviorSubject<int> _readCountController = BehaviorSubject<int>();

  Stream<int> get readCount => _readCountController.stream;

  void updateReadCount(int count) {
    if (!_readCountController.isClosed) {
      _readCountController.sink.add(count);
    }
  }

  void dispose() {
    _readCountController.close();
  }
}

final bookListBloc = BookListBloc();
