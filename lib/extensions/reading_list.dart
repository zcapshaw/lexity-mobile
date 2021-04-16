import '../models/models.dart';

extension ReadingList<T> on List<ListedBook> {
  static int headerPlaceholder = 1;

  int get readingCount => where((book) => book.reading).toList().length;

  int get toReadCount => where((book) => book.toRead).toList().length;

  int get readCount => where((book) => book.read).toList().length;

  int get lengthWithoutRead => length - readCount;

  int get lengthWithoutReadPlusHeader => length - readCount + headerPlaceholder;

  int get readingCountExcludingHeader => readingCount - headerPlaceholder;

  int get toReadCountExcludingHeader => toReadCount - headerPlaceholder;

  int get readCountExcludingHeader => readCount - headerPlaceholder;

  List<ListedBook> get removeHeaders =>
      where((book) => book.runtimeType != ListedBookHeader).toList();
}
