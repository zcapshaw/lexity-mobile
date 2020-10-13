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

  int countByType(String type) {
    int count;
    switch (type) {
      case 'READING':
        count = this.readingCount;
        break;
      case 'TO_READ':
        count = this.toReadCount;
        break;
      case 'READ':
        count = this.readCount;
        break;
    }
    return count ?? 0;
  }

  @override
  String toString() {
    return 'StatsLoadSuccess { readingCount: $readingCount, toReadCount: $toReadCount, readCount: $readCount }';
  }
}
