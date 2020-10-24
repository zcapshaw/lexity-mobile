import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:lexity_mobile/repositories/repositories.dart';
import '../test_variables.dart';

void main() {
  User user;
  ListRepository listRepository;
  ListedBook listBookOne;
  ListedBook listBookTwo;
  ListedBook modifiedListBookOne;
  ListedBook newBook;
  ListedBook existingBook;
  ListedBookHeader readingHeader;
  ListedBookHeader toReadHeader;
  ListedBookHeader readHeader;

  setUp(() {
    user = User(id: 'Users/12345', accessToken: 'abc123');
    listRepository = ListRepository();
    listBookOne = TestVariables.listBookOne;
    listBookTwo = TestVariables.listBookTwo;
    modifiedListBookOne = TestVariables.modifiedBookOne;
    newBook = TestVariables.newBook;
    existingBook = TestVariables.existingBook;
    readingHeader = ListedBookHeader('READING');
    toReadHeader = ListedBookHeader('TO_READ');
    readHeader = ListedBookHeader('READ');
  });

  test('Headers are correctly injected into the readingList', () {
    expect(
        listRepository.sortByTypeAndInjectHeaders([listBookOne, listBookTwo]),
        [readingHeader, listBookOne, toReadHeader, listBookTwo, readHeader]);
  });

  test('New book is added to list in correct position', () {
    expect(
        listRepository.addBook(newBook, [
          readingHeader,
          listBookOne,
          toReadHeader,
          listBookTwo,
          readHeader
        ]),
        [
          readingHeader,
          listBookOne,
          newBook,
          toReadHeader,
          listBookTwo,
          readHeader
        ]);
  });

  test('Existing book is added to list with appended recos, notes, labels', () {
    expect(
        listRepository.addBook(existingBook, [
          readingHeader,
          listBookOne,
          toReadHeader,
          listBookTwo,
          readHeader
        ]),
        [
          readingHeader,
          toReadHeader,
          listBookTwo,
          modifiedListBookOne,
          readHeader
        ]);
  });

  test('Updated book with different type is moved to appropriate index', () {
    ListedBook listBookTwoRead = listBookTwo.clone()..changeType = 'READ';
    expect(
        listRepository.updateBookTypeIndex(
          listBookTwoRead,
          [
            readingHeader,
            listBookOne,
            toReadHeader,
            listBookTwoRead,
            readHeader
          ],
          [readingHeader, listBookOne, toReadHeader, listBookTwo, readHeader],
        ),
        [
          readingHeader,
          listBookOne,
          toReadHeader,
          readHeader,
          listBookTwoRead
        ]);
  });

  test('Reordered book is moved to appropriate index with type changed', () {
    expect(
        listRepository.reorderBook(
            [readingHeader, listBookOne, toReadHeader, listBookTwo, readHeader],
            1,
            3,
            user,
            true),
        [readingHeader, toReadHeader, listBookOne, listBookTwo, readHeader]);
  });

  test('When isHomeScreen is true, ensure all reorders adhere to max index',
      () {
    expect(
        listRepository.reorderBook(
            [readingHeader, listBookOne, toReadHeader, listBookTwo, readHeader],
            1,
            10,
            user,
            true),
        [readingHeader, toReadHeader, listBookTwo, listBookOne, readHeader]);
  });
}
