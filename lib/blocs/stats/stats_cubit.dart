import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../blocs.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final ReadingListBloc readingListBloc;
  StreamSubscription readingListSubscription;

  StatsCubit({@required this.readingListBloc}) : super(StatsLoadInProgress()) {
    readingListSubscription = readingListBloc.listen((state) {
      if (state is ReadingListLoadSuccess) {
        int toReadCount =
            state.readingList.where((book) => book.toRead).toList().length;

        int readingCount =
            state.readingList.where((book) => book.reading).toList().length;

        int readCount =
            state.readingList.where((book) => book.read).toList().length;
        emit(StatsLoadSuccess(toReadCount, readingCount, readCount));
      }
    });
  }

  @override
  Future<void> close() {
    readingListSubscription.cancel();
    return super.close();
  }
}
