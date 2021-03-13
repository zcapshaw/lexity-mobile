part of 'book_details_cubit.dart';

@immutable
abstract class BookDetailsState extends Equatable {
  const BookDetailsState();

  @override
  List<Object> get props => [];

  ListedBook get book => null;
  List<Note> get notes => null;
  List<Note> get recos => null;
}

// The default state, if no book is selected
class BookDetailsLoading extends BookDetailsState {
  const BookDetailsLoading();
}

// The following 4 states allow the screen to
// conditionally show correct action buttons
class BookDetailsReading extends BookDetailsState {
  const BookDetailsReading(this.book, [this.recos, this.notes]);

  @override
  final ListedBook book;
  @override
  final List<Note> recos;
  @override
  final List<Note> notes;

  @override
  List<Object> get props => [book, recos, notes];
}

class BookDetailsWantToRead extends BookDetailsState {
  const BookDetailsWantToRead(this.book, [this.recos, this.notes]);

  @override
  final ListedBook book;
  @override
  final List<Note> recos;
  @override
  final List<Note> notes;

  @override
  List<Object> get props => [book, recos, notes];
}

class BookDetailsFinished extends BookDetailsState {
  const BookDetailsFinished(this.book, [this.recos, this.notes]);

  @override
  final ListedBook book;
  @override
  final List<Note> recos;
  @override
  final List<Note> notes;

  @override
  List<Object> get props => [book, recos, notes];
}

class BookDetailsUnlisted extends BookDetailsState {
  const BookDetailsUnlisted(this.book, [this.recos, this.notes]);

  @override
  final ListedBook book;
  @override
  final List<Note> recos;
  @override
  final List<Note> notes;

  @override
  List<Object> get props => [book, recos, notes];
}
