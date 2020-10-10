part of 'stats_cubit.dart';

@immutable
abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

class StatsLoadInProgress extends StatsState {}

class StatsLoadSuccess extends StatsState {
  final int toReadCount;
  final int readingCount;
  final int readCount;

  const StatsLoadSuccess(this.toReadCount, this.readingCount, this.readCount);

  @override
  List<Object> get props => [toReadCount, readingCount, readCount];

  @override
  String toString() {
    return 'StatsLoadSuccess { toReadCount: $toReadCount, readingCount: $readingCount, readCount: $readCount }';
  }
}
