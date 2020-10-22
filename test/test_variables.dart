import 'package:lexity_mobile/models/models.dart';

class TestVariables {
  static ListedBook listBookOne = ListedBook(
      bookId: 'abc123',
      title: 'The best test book ever',
      type: 'READING',
      recos: [
        Note(sourceName: 'Daniel', sourceImg: null),
        Note(sourceName: 'Zach', sourceImg: null)
      ],
      notes: [
        Note(comment: 'Check out this epic note')
      ],
      labels: []);

  static ListedBook listBookTwo = ListedBook(
      bookId: 'def456', title: 'Bad book that is popular', type: 'TO_READ');

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
      labels: []);

  static ListedBook newBook =
      ListedBook(bookId: 'hij678', title: 'Parry Hotter', type: 'READING');

  static ListedBook modifiedBookOne = ListedBook(
      bookId: 'abc123',
      title: 'The best test book ever',
      type: 'TO_READ',
      recos: [
        Note(sourceName: 'Daniel', sourceImg: null),
        Note(sourceName: 'Joe', sourceImg: null),
        Note(sourceName: 'Zach', sourceImg: null)
      ],
      notes: [
        Note(comment: 'Sweet ass note!'),
        Note(comment: 'Check out this epic note')
      ],
      labels: []);
}
