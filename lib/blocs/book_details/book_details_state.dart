part of 'book_details_cubit.dart';

@immutable
abstract class BookDetailsState {
  const BookDetailsState();
}

//TODO: add following states:
// loading ✓
// want to read
// reading
// finished
// not listed
class BookDetailsLoading extends BookDetailsState {
  const BookDetailsLoading();
}

class BookDetailsReading extends BookDetailsState {
  final ListItem book;
  const BookDetailsReading(this.book);
}
