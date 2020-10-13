import '../models/models.dart';

extension ReadingList<T> on List<ListedBook> {
  static int headerPlaceholder = 1;

  int get readingCount => this.where((book) => book.reading).toList().length;

  int get toReadCount => this.where((book) => book.toRead).toList().length;

  int get readCount => this.where((book) => book.read).toList().length;

  int get lengthWithoutRead => this.length - this.readCount;

  int get readingCountExcludingHeader => this.readingCount - headerPlaceholder;

  int get toReadCountExcludingHeader => this.toReadCount - headerPlaceholder;

  int get readCountExcludingHeader => this.readCount - headerPlaceholder;
}
