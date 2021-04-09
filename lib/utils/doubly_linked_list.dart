import 'package:lexity_mobile/models/listed_book.dart';
import 'package:lexity_mobile/models/user.dart';

class DoublyLinkedList {
  /// Make appropriate updates to prev, next, firstNode and lastNode of the
  /// doubly linked list to ensure list integrity. Updates will be made on local
  /// models and a list of books returned which can be passed to
  /// addOrUpdateListItem on the backend to ensure syncing. If the User.list obj
  /// with firstNode and lastNode change, this function will handle backend sync
  /// with the ListService. IMPORTANT: This function assumes that the moved book
  /// HAS BEEN moved to the newIndex and the oldIndex represents the book now
  /// in it's place.
  List<ListedBook> moveExistingBook(
      User user, List<ListedBook> readingList, int oldIndex, int newIndex) {
    var listLen = readingList.length;
    // newIndex == 1 is the list first position, because position 0 is the
    // 'READING' header added to the list
    if (newIndex == 1 && oldIndex == listLen - 1) {
      return _moveExistingBookFromEndToBeginning(
          user, readingList, oldIndex, newIndex);
    } else if (newIndex == listLen - 1 && oldIndex == 1) {
      return _moveExistingBookFromBeginningToEnd(
          user, readingList, oldIndex, newIndex);
    } else if (newIndex == 1) {
      return _moveExistingBookToBeginning(
          user, readingList, oldIndex, newIndex);
    } else if (newIndex == listLen - 1) {
      return _moveExistingBookToEnd(user, readingList, oldIndex, newIndex);
    } else {
      return _moveExistingBook(readingList, oldIndex, newIndex);
    }
  }

  List<ListedBook> _moveExistingBookFromEndToBeginning(
      User user, List<ListedBook> readingList, int oldIndex, int newIndex) {
    // Set firstNode to bookId of book being moved to the beginning and set
    // lastNode to bookId of book now in the last position, given the moved book
    user.list['firstNode'] = readingList[newIndex].bookId;
    user.list['lastNode'] = readingList[oldIndex - 1].bookId;

    readingList[newIndex].prev = null;
    readingList[newIndex].next = readingList[newIndex + 1].bookId;
    readingList[newIndex + 1].prev = readingList[newIndex].bookId;
    readingList[oldIndex].next = null;

    return [
      readingList[newIndex],
      readingList[newIndex + 1].linkListOnly(),
      readingList[oldIndex].linkListOnly()
    ];
  }

  List<ListedBook> _moveExistingBookFromBeginningToEnd(
      User user, List<ListedBook> readingList, int oldIndex, int newIndex) {
    // Set firstNode to bookId of new firstNode from the implied oldIndex of 1
    // lastNode to bookId of book being moved to the end of the list
    user.list['firstNode'] = readingList[oldIndex].bookId;
    user.list['lastNode'] = readingList[newIndex].bookId;

    readingList[newIndex].prev = readingList[newIndex - 1].bookId;
    readingList[newIndex].next = null;
    readingList[newIndex - 1].next = readingList[newIndex].bookId;
    readingList[oldIndex].prev = null;

    return [
      readingList[newIndex],
      readingList[newIndex - 1].linkListOnly(),
      readingList[oldIndex].linkListOnly()
    ];
  }

  List<ListedBook> _moveExistingBookToBeginning(
      User user, List<ListedBook> readingList, int oldIndex, int newIndex) {
    // Set firstNode to bookId of book being moved to the beginning
    user.list['firstNode'] = readingList[newIndex].bookId;

    readingList[newIndex].prev = null;
    readingList[newIndex].next = readingList[newIndex + 1].bookId;
    readingList[newIndex + 1].prev = readingList[newIndex].bookId;
    readingList[oldIndex].next = readingList[oldIndex + 1].bookId;
    readingList[oldIndex + 1].prev = readingList[oldIndex].bookId;

    return [
      readingList[newIndex],
      readingList[newIndex + 1].linkListOnly(),
      readingList[oldIndex].linkListOnly(),
      readingList[oldIndex + 1].linkListOnly()
    ];
  }

  List<ListedBook> _moveExistingBookToEnd(
      User user, List<ListedBook> readingList, int oldIndex, int newIndex) {
    // Set lastNode to bookId of book being moved to the end of the list
    user.list['lastNode'] = readingList[newIndex].bookId;

    readingList[newIndex].prev = readingList[newIndex - 1].bookId;
    readingList[newIndex].next = null;
    readingList[newIndex - 1].next = readingList[newIndex].bookId;
    readingList[oldIndex].prev = readingList[oldIndex - 1].bookId;
    readingList[oldIndex - 1].next = readingList[oldIndex].bookId;

    return [
      readingList[newIndex],
      readingList[newIndex - 1].linkListOnly(),
      readingList[oldIndex].linkListOnly(),
      readingList[oldIndex - 1].linkListOnly()
    ];
  }

  //TODO Add conditional because whether oldIndex is greater than newIndex matters here
  List<ListedBook> _moveExistingBook(
      List<ListedBook> readingList, int oldIndex, int newIndex) {
    readingList[newIndex].prev = readingList[newIndex - 1].bookId;
    readingList[newIndex].next = readingList[newIndex + 1].bookId;
    readingList[newIndex - 1].next = readingList[newIndex].bookId;
    readingList[newIndex + 1].prev = readingList[newIndex].bookId;
    readingList[oldIndex].prev = readingList[oldIndex - 1].bookId;
    readingList[oldIndex - 1].next = readingList[oldIndex].bookId;

    return [
      readingList[newIndex],
      readingList[newIndex - 1].linkListOnly(),
      readingList[newIndex + 1].linkListOnly(),
      readingList[oldIndex].linkListOnly(),
      readingList[oldIndex - 1].linkListOnly()
    ];
  }
}
