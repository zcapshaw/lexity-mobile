import 'package:bloc/bloc.dart';
import 'package:lexity_mobile/models/list_item.dart';
import 'package:meta/meta.dart';

part 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  BookDetailsCubit() : super(BookDetailsLoading());

  void viewBookDetails(ListItem book) {
    emit(BookDetailsReading(book));
  }
}
