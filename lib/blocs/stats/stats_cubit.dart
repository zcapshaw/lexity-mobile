import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../blocs.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit({@required this.readingListBloc}) : super(StatsLoadInProgress()) {
    readingListSubscription = readingListBloc.listen((state) {
      if (state is ReadingListLoadSuccess) {
        // Remove a header placeholder to count only ListedBooks
        final headerPlaceholder = 1;
        var readingCount =
            state.readingList.where((book) => book.reading).toList().length -
                headerPlaceholder;
        var toReadCount =
            state.readingList.where((book) => book.toRead).toList().length -
                headerPlaceholder;
        var readCount =
            state.readingList.where((book) => book.read).toList().length -
                headerPlaceholder;
        emit(StatsLoadSuccess(readingCount, toReadCount, readCount));
      }
    });
  }

  final ReadingListBloc readingListBloc;
  StreamSubscription readingListSubscription;

  @override
  Future<void> close() {
    readingListSubscription.cancel();
    return super.close();
  }
}
