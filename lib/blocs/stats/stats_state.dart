part of 'stats_cubit.dart';

@immutable
abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

class StatsLoadInProgress extends StatsState {}

class StatsLoadSuccess extends StatsState {
  final int readingCount;
  final int toReadCount;
  final int readCount;

  const StatsLoadSuccess(this.readingCount, this.toReadCount, this.readCount);

  @override
  List<Object> get props => [readingCount, toReadCount, readCount];

  @override
  String toString() {
    return 'StatsLoadSuccess { readingCount: $readingCount, toReadCount: $toReadCount, readCount: $readCount }';
  }
}
