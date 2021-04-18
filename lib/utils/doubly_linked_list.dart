import 'package:pedantic/pedantic.dart';
import 'package:lexity_mobile/models/listed_book.dart';
import 'package:lexity_mobile/models/user.dart';
import 'package:lexity_mobile/extensions/extensions.dart';
import 'package:lexity_mobile/services/services.dart';

class DoublyLinkedList {
  ListService listService = ListService();

  ///
  /// Make appropriate updates to prev, next, firstNode and lastNode of the
  /// doubly linked list to ensure list integrity. Updates will be made on local
  /// models and a list of books returned which can be passed to
  /// addOrUpdateListItem on the backend to ensure syncing. If the User.list obj
  /// with firstNode and lastNode change, this function will handle backend sync
  /// with the ListService.
  ///
  List<ListedBook> addBook(User user, List<ListedBook> readingList, int index) {
    // Establish identities, considering that this list has ListedBookHeader
    // runtimeTypes that we have to be aware of
    var books = <ListedBook>[];
    var newBook = readingList[index];
    var newBookNext = _getNextBookOrNull(readingList, index);
    var newBookPrev = _getPrevBookOrNull(readingList, index);

    //Updates list firstNode and/or lastNode if neccessary
    _checkUserListAndSync(user, readingList);

    newBook
      // These could be null if it's the only book
      ..prev = newBookPrev?.bookId
      ..next = newBookNext?.bookId;
    books.add(newBook);

    if (newBookPrev != null) {
      newBookPrev.next = newBook.bookId;
      books.add(newBookPrev.linkListOnly());
    }

    if (newBookNext != null) {
      newBookNext.prev = newBook.bookId;
      books.add(newBookNext.linkListOnly());
    }

    return books;
  }

  ///
  /// Make appropriate updates to prev, next, firstNode and lastNode of the
  /// doubly linked list to ensure list integrity. Updates will be made on local
  /// models and a list of books returned which can be passed to
  /// addOrUpdateListItem on the backend to ensure syncing. If the User.list obj
  /// with firstNode and lastNode change, this function will handle backend sync
  /// with the ListService. IMPORTANT: This function assumes that the moved book
  /// HAS BEEN moved to the newIndex and the oldIndex represents the book now
  /// in it's place.
  ///
  List<ListedBook> moveExistingBook(
      User user, List<ListedBook> readingList, int oldIndex, int newIndex) {
    // Establish identities, considering that this list has ListedBookHeader
    // runtimeTypes that we have to be aware of
    var books = <ListedBook>[];
    ListedBook oldBook;
    ListedBook oldBookAdjacent;
    var newBook = readingList[newIndex];
    var newBookNext = _getNextBookOrNull(readingList, newIndex);
    var newBookPrev = _getPrevBookOrNull(readingList, newIndex);

    //Updates list firstNode and/or lastNode if neccessary
    _checkUserListAndSync(user, readingList);

    newBook
      // These could be null if it's the only book
      ..prev = newBookPrev?.bookId
      ..next = newBookNext?.bookId;
    books.add(newBook);

    if (newBookPrev != null) {
      newBookPrev.next = newBook.bookId;
      books.add(newBookPrev.linkListOnly());
    }

    if (newBookNext != null) {
      newBookNext.prev = newBook.bookId;
      books.add(newBookNext.linkListOnly());
    }

    // If newIndex > oldIndex, then oldIndex represents a ListedBook slid
    // from back, whereas if newIndex is < oldIndex, then oldIndex represents a
    // ListedBook slid from front - how you handle oldIndex changes
    if (newIndex > oldIndex) {
      oldBook = readingList[oldIndex].runtimeType != ListedBookHeader
          ? readingList[oldIndex]
          : _getNextBookOrNull(readingList, oldIndex);
      oldBookAdjacent = _getPrevBookOrNull(readingList, oldIndex);
      oldBook.prev = oldBookAdjacent?.bookId;
      if (oldBook.bookId != newBook.bookId) {
        // These could be the same
        books.add(oldBook.linkListOnly());
      }
      if (oldBookAdjacent != null) {
        oldBookAdjacent.next = oldBook.bookId;
        books.add(oldBookAdjacent.linkListOnly());
      }
    } else {
      oldBook = readingList[oldIndex].runtimeType != ListedBookHeader
          ? readingList[oldIndex]
          : _getPrevBookOrNull(readingList, oldIndex);
      oldBookAdjacent = _getNextBookOrNull(readingList, oldIndex);
      oldBook.next = oldBookAdjacent?.bookId;
      if (oldBook.bookId != newBook.bookId) {
        // These could be the same
        books.add(oldBook.linkListOnly());
      }
      if (oldBookAdjacent != null) {
        oldBookAdjacent.prev = oldBook.bookId;
        books.add(oldBookAdjacent.linkListOnly());
      }
    }

    return books;
  }

  ListedBook _getNextBookOrNull(List<ListedBook> readingList, int start) {
    ListedBook nextBook;
    var len = readingList.length;
    if (start < len) {
      // Exit to null if start index is last list position
      for (var i = start + 1; i < len; i++) {
        if (readingList[i].runtimeType != ListedBookHeader) {
          nextBook = readingList[i];
          break;
        }
      }
    }
    return nextBook;
  }

  ListedBook _getPrevBookOrNull(List<ListedBook> readingList, int start) {
    ListedBook prevBook;
    if (start > 1) {
      // 1 is the last book because 0 is header. No prev if at first listed book
      for (var i = start - 1; i >= 0; i--) {
        if (readingList[i].runtimeType != ListedBookHeader) {
          prevBook = readingList[i];
          break;
        }
      }
    }
    return prevBook;
  }

  void _checkUserListAndSync(User user, List<ListedBook> readingList) async {
    if (user.list['firstNode'] != readingList.firstBook.bookId ||
        user.list['lastNode'] != readingList.lastBook.bookId) {
      user.list['firstNode'] = readingList.firstBook.bookId;
      user.list['lastNode'] = readingList.lastBook.bookId;
      var userUpdate = {'list': user.list};

      // update the list firstNode/lastNode in the backend/DB
      unawaited(listService.updateUser(user, userUpdate));
    }
  }
}
