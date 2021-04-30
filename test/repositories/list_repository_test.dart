import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:lexity_mobile/repositories/repositories.dart';
import '../test_variables.dart';

void main() {
  User user;
  ListRepository listRepository;
  ListedBook listBookOne;
  ListedBook listBookTwo;
  ListedBook listBookThree;
  ListedBook listBookFour;
  ListedBook listBookLast;
  ListedBook modifiedListBookOne;
  ListedBook newBook;
  ListedBook existingBook;
  ListedBookHeader readingHeader;
  ListedBookHeader toReadHeader;
  ListedBookHeader readHeader;

  setUp(() {
    var list = {'firstNode': 'abc123', 'lastNode': 'qrs456'};
    user = User(id: 'Users/12345', accessToken: 'abc123', list: list);
    listRepository = ListRepository();
    listBookOne = TestVariables.listBookOne;
    listBookTwo = TestVariables.listBookTwo;
    listBookThree = TestVariables.listBookThree;
    listBookFour = TestVariables.listBookFour;
    listBookLast = TestVariables.listBookLast;
    modifiedListBookOne = TestVariables.modifiedBookOne;
    newBook = TestVariables.newBook;
    existingBook = TestVariables.existingBook;
    readingHeader = ListedBookHeader('READING');
    toReadHeader = ListedBookHeader('TO_READ');
    readHeader = ListedBookHeader('READ');
  });

  test('Headers are correctly injected into the readingList', () {
    expect(
        listRepository.sortByTypeAndInjectHeaders([
          listBookOne,
          listBookTwo,
          listBookThree,
          listBookFour,
          listBookLast
        ]),
        [
          readingHeader,
          listBookOne,
          listBookTwo,
          toReadHeader,
          listBookThree,
          readHeader,
          listBookFour,
          listBookLast
        ]);
  });

  test('New book is added to list in correct position w saved list order', () {
    expect(
        listRepository.addBook(user, newBook, [
          readingHeader,
          listBookOne,
          listBookTwo,
          toReadHeader,
          listBookThree,
          readHeader,
          listBookFour,
          listBookLast
        ]),
        [
          readingHeader,
          listBookOne,
          listBookTwo.clone(next: 'hij678'),
          newBook,
          toReadHeader,
          listBookThree.clone(prev: 'hij678'),
          readHeader,
          listBookFour,
          listBookLast,
        ]);
  });

  test(
      'Existing book is added to list with appended recos, notes, labels - type change updates list position w saved list order',
      () {
    expect(
        listRepository.addBook(user, existingBook, [
          readingHeader,
          listBookOne,
          listBookTwo,
          toReadHeader,
          listBookThree,
          readHeader,
          listBookFour,
          listBookLast
        ]),
        [
          readingHeader,
          listBookTwo.clone(prev: null),
          toReadHeader,
          listBookThree.clone(next: 'abc123'),
          modifiedListBookOne,
          readHeader,
          listBookFour.clone(prev: 'abc123'),
          listBookLast,
        ]);
  });

  test(
      'Updated book with different type is moved to appropriate index w saved list order',
      () {
    var listBookTwoRead = listBookTwo.clone(prev: 'klm189', next: 'nop123')
      ..changeType = 'READ';
    expect(
        listRepository.updateBook(user, listBookTwoRead, [
          readingHeader,
          listBookOne,
          listBookTwo,
          toReadHeader,
          listBookThree,
          readHeader,
          listBookFour,
          listBookLast
        ]),
        [
          readingHeader,
          listBookOne.clone(next: 'klm789'),
          toReadHeader,
          listBookThree.clone(prev: 'abc123'),
          readHeader,
          listBookTwoRead,
          listBookFour.clone(prev: 'def456'),
          listBookLast
        ]);
  });

  test('Reordered book is moved to appropriate index with type changed', () {
    expect(
        listRepository.reorderBook([
          readingHeader,
          listBookOne,
          listBookTwo,
          toReadHeader,
          listBookThree,
          readHeader,
          listBookFour,
          listBookLast
        ], 1, 4, user, true),
        [
          readingHeader,
          listBookTwo.clone(prev: null, next: 'abc123'),
          toReadHeader,
          listBookOne.clone(prev: 'def456', next: 'klm789'),
          listBookThree.clone(prev: 'abc123'),
          readHeader,
          listBookFour,
          listBookLast
        ]);
  });

  test('When isHomeScreen is true, ensure all reorders adhere to max index',
      () {
    expect(
        listRepository.reorderBook([
          readingHeader,
          listBookOne,
          listBookTwo,
          toReadHeader,
          listBookThree,
          readHeader,
          listBookFour,
          listBookLast
        ], 1, 10, user, true),
        [
          readingHeader,
          listBookTwo.clone(prev: null),
          toReadHeader,
          listBookThree.clone(next: 'abc123'),
          listBookOne.clone(prev: 'klm789', next: 'nop123'),
          readHeader,
          listBookFour,
          listBookLast
        ]);
  });

  test('Reordered book moved to end of list has appropriate link list updates',
      () {
    expect(
        listRepository.reorderBook([
          readingHeader,
          listBookOne,
          listBookTwo,
          toReadHeader,
          listBookThree,
          readHeader,
          listBookFour,
          listBookLast
        ], 1, 8, user, false),
        [
          readingHeader,
          listBookTwo.clone(prev: null),
          toReadHeader,
          listBookThree,
          readHeader,
          listBookFour,
          listBookLast.clone(next: 'abc123'),
          listBookOne.clone(prev: 'qrs456', next: null),
        ]);
  });
}
