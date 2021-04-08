import 'package:lexity_mobile/models/listed_book.dart';

class DoublyLinkedList {
  List moveExistingBook(
      List<ListedBook> readingList, int oldIndex, int newIndex) {
    var updatedBooks = [dynamic];
    // Book prior to old index has a next value of oldIndex.bookId OR null
    readingList[oldIndex - 1].next = readingList[oldIndex]?.bookId;
    // If not null, then oldIndex was NOT the end of the list, and book in it's
    // place should have the prev value updated
    if (readingList[oldIndex - 1].next != null) {
      readingList[oldIndex].prev = readingList[oldIndex - 1].bookId;
    }
  }
}
