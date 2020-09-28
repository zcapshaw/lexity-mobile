part of 'book_details_cubit.dart';

@immutable
abstract class BookDetailsState {
  const BookDetailsState();

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

//Note I omitted some boilerplate from the Equatable.dart library that was shown in bloclibrary tutorials
//we may want to revisit if that code is needed if we see buggy behavior with state changes
