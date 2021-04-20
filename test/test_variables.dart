import 'package:lexity_mobile/models/models.dart';

class TestVariables {
  static ListedBook listBookOne = ListedBook(
      bookId: 'abc123',
      title: 'The best test book ever',
      type: 'READING',
      prev: null,
      next: 'def456',
      recos: [
        Note(sourceName: 'Daniel', sourceImg: null),
        Note(sourceName: 'Zach', sourceImg: null)
      ],
      notes: [
        Note(comment: 'Check out this epic note')
      ],
      labels: <String>[]);

  static ListedBook listBookTwo = ListedBook(
    bookId: 'def456',
    title: 'Bad book that is popular',
    type: 'READING',
    prev: 'abc123',
    next: 'klm789',
  );

  static ListedBook listBookThree = ListedBook(
      bookId: 'klm789',
      title: 'Twilight Mylight',
      type: 'TO_READ',
      prev: 'def456',
      next: 'nop123');

  static ListedBook listBookFour = ListedBook(
      bookId: 'nop123',
      title: 'Yellow Fellow',
      type: 'READ',
      prev: 'klm789',
      next: 'qrs456');

  static ListedBook listBookLast = ListedBook(
      bookId: 'qrs456',
      title: 'Peanut Butter Jelly Time',
      type: 'READ',
      prev: 'nop123',
      next: null);

  static ListedBook existingBook = ListedBook(
      bookId: 'abc123',
      title: 'The best test book ever',
      type: 'TO_READ',
      recos: [
        Note(sourceName: 'Daniel', sourceImg: null),
        Note(sourceName: 'Joe', sourceImg: null)
      ],
      notes: [
        Note(comment: 'Sweet ass note!')
      ],
      labels: <String>[]);

  static ListedBook newBook = ListedBook(
      bookId: 'hij678',
      title: 'Parry Hotter',
      type: 'READING',
      prev: 'def456',
      next: 'klm789');

  static ListedBook modifiedBookOne = ListedBook(
      bookId: 'abc123',
      title: 'The best test book ever',
      type: 'TO_READ',
      prev: 'klm789',
      next: 'nop123',
      recos: [
        Note(sourceName: 'Daniel', sourceImg: null),
        Note(sourceName: 'Joe', sourceImg: null),
        Note(sourceName: 'Zach', sourceImg: null)
      ],
      notes: [
        Note(comment: 'Sweet ass note!'),
        Note(comment: 'Check out this epic note')
      ],
      labels: <String>[]);
}
