part of 'book_details_cubit.dart';

@immutable
abstract class BookDetailsState extends Equatable {
  const BookDetailsState();

  @override
  List<Object> get props => [];

  ListedBook get book => null;
}

// The default state, if no book is selected
class BookDetailsLoading extends BookDetailsState {
  const BookDetailsLoading();
}

// The following 4 states allow the screen to
// conditionally show correct action buttons
class BookDetailsReading extends BookDetailsState {
  const BookDetailsReading(this.book);
  final ListedBook book;

  @override
  List<Object> get props => [book];
}

class BookDetailsWantToRead extends BookDetailsState {
  const BookDetailsWantToRead(this.book);
  final ListedBook book;

  @override
  List<Object> get props => [book];
}

class BookDetailsFinished extends BookDetailsState {
  const BookDetailsFinished(this.book);
  final ListedBook book;

  @override
  List<Object> get props => [book];
}

class BookDetailsUnlisted extends BookDetailsState {
  const BookDetailsUnlisted(this.book);
  final ListedBook book;

  @override
  List<Object> get props => [book];
}
