import 'package:bloc/bloc.dart';
import 'package:lexity_mobile/models/list_item.dart';
import 'package:meta/meta.dart';

part 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  BookDetailsCubit() : super(BookDetailsLoading());

  void viewBookDetails(ListItem book) {
    if (book.type == 'READING') {
      emit(BookDetailsReading(book));
    } else if (book.type == 'TO_READ') {
      emit(BookDetailsWantToRead(book));
    } else if (book.type == 'READ') {
      emit(BookDetailsFinished(book));
    } else {
      emit(BookDetailsUnlisted(book));
    }
  }
}
