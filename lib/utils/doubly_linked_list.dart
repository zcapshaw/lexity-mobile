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
    // Establish identities, considering that this list has ListedBookHeader
    // runtimeTypes that we have to be aware of
    var books = <ListedBook>[];
    ListedBook oldBook;
    ListedBook oldBookAdjacent;
    var newBook = readingList[newIndex];
    var newBookNext = _getNextBookOrNull(readingList, newIndex);
    var newBookPrev = _getPrevBookOrNull(readingList, newIndex);

    //TODO create a function to check for and, if neccessary, update first/last

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

  List<ListedBook> moveExistingBookOld(
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
    // Establish identities, considering that this list has ListedBookHeader
    // runtimeTypes that we have to be aware of
    List<ListedBook> books;
    var newBook = readingList[newIndex];
    var newBookNext = _getNextBookOrNull(readingList, newIndex);
    var oldBook = readingList[oldIndex].runtimeType != ListedBookHeader
        ? readingList[oldIndex]
        : _getPrevBookOrNull(readingList, oldIndex);

    // Set firstNode to bookId of book being moved to the beginning and set and
    // lastNode to bookId of book now in the last position, given the moved book
    // - if there is only one book in the list, lastNode will = firstNode.
    user.list['firstNode'] = newBook.bookId;
    user.list['lastNode'] = oldBook.bookId;

    newBook
      ..prev = null
      ..next = newBookNext?.bookId; // This could be null if it's the only book
    books.add(newBook);

    oldBook.next = null;
    books.add(oldBook.linkListOnly());

    if (newBookNext != null) {
      newBookNext.prev = newBook.bookId;
      books.add(newBookNext.linkListOnly());
    }
    return books;
  }

  List<ListedBook> _moveExistingBookFromBeginningToEnd(
      User user, List<ListedBook> readingList, int oldIndex, int newIndex) {
    // Establish identities, considering that this list has ListedBookHeader
    // runtimeTypes that we have to be aware of
    List<ListedBook> books;
    var newBook = readingList[newIndex];
    var newBookPrev = _getPrevBookOrNull(readingList, newIndex);
    var oldBook = readingList[oldIndex].runtimeType != ListedBookHeader
        ? readingList[oldIndex]
        : _getNextBookOrNull(readingList, oldIndex);

    // Set firstNode to bookId of new firstNode from the implied oldIndex of 1
    // - if there is only one book in the list, firstNode will = lastNode.
    // Set lastNode to bookId of book being moved to the end of the list
    user.list['firstNode'] = oldBook.bookId;
    user.list['lastNode'] = newBook.bookId;

    newBook
      ..prev = newBookPrev?.bookId // This could be null if it's the only book
      ..next = null;
    books.add(newBook);

    oldBook.prev = null;
    books.add(oldBook.linkListOnly());

    if (newBookPrev != null) {
      newBookPrev.next = newBook.bookId;
      books.add(newBookPrev.linkListOnly());
    }
    return books;
  }

  List<ListedBook> _moveExistingBookToBeginning(
      User user, List<ListedBook> readingList, int oldIndex, int newIndex) {
    // Establish identities, considering that this list has ListedBookHeader
    // runtimeTypes that we have to be aware of
    List<ListedBook> books;
    var newBook = readingList[newIndex];
    var newBookNext = _getNextBookOrNull(readingList, newIndex);
    var oldBook = readingList[oldIndex].runtimeType != ListedBookHeader
        ? readingList[oldIndex]
        : _getNextBookOrNull(readingList, oldIndex);
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

  List<ListedBook> _moveExistingBook(
      List<ListedBook> readingList, int oldIndex, int newIndex) {
    readingList[newIndex].prev = readingList[newIndex - 1].bookId;
    readingList[newIndex].next = readingList[newIndex + 1].bookId;
    readingList[newIndex - 1].next = readingList[newIndex].bookId;
    readingList[newIndex + 1].prev = readingList[newIndex].bookId;
    if (newIndex > oldIndex) {
      readingList[oldIndex].prev = readingList[oldIndex - 1].bookId;
      readingList[oldIndex - 1].next = readingList[oldIndex].bookId;
    } else {
      readingList[oldIndex].next = readingList[oldIndex + 1].bookId;
      readingList[oldIndex + 1].prev = readingList[oldIndex].bookId;
    }
    return [
      readingList[newIndex],
      readingList[newIndex - 1].linkListOnly(),
      readingList[newIndex + 1].linkListOnly(),
      readingList[oldIndex].linkListOnly(),
      newIndex > oldIndex
          ? readingList[oldIndex - 1].linkListOnly()
          : readingList[oldIndex + 1].linkListOnly(),
    ];
  }

  /// Headers will need to be stripped from the Reading List in order to
  /// effectively update the prev/next values of books without inadvertantly
  /// modifying a subclass ListedBookHeader. This removal of headers will
  /// also impact the indexes which are based on the header list
  int _getIndexWithoutHeaders(int index, int readingCount, int toReadCount) {
    if (index > readingCount + toReadCount) {
      // book is located after 3 headers
      return index - 3;
    } else if (index > readingCount) {
      // book is located after 2 headers
      return index - 2;
    } else {
      return index - 1; // all other books are listed after 1 header (at least)
    }
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
}
