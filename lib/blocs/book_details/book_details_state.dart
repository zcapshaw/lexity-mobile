part of 'book_details_cubit.dart';

@immutable
abstract class BookDetailsState extends Equatable {
  const BookDetailsState();

  @override
  List<Object> get props => [];

  get book => null;
}

//The default state, if no book is selected
class BookDetailsLoading extends BookDetailsState {
  const BookDetailsLoading();
}

//The following 4 states allow the screen to conditionally show correct action buttons
class BookDetailsReading extends BookDetailsState {
  final ListItem book;
  const BookDetailsReading(this.book);
}

class BookDetailsWantToRead extends BookDetailsState {
  final ListItem book;
  const BookDetailsWantToRead(this.book);
}

class BookDetailsFinished extends BookDetailsState {
  final ListItem book;
  const BookDetailsFinished(this.book);
}

class BookDetailsUnlisted extends BookDetailsState {
  final ListItem book;
  const BookDetailsUnlisted(this.book);
}
