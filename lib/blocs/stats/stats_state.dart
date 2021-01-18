part of 'stats_cubit.dart';

@immutable
abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

class StatsLoadInProgress extends StatsState {}

class StatsLoadSuccess extends StatsState {
  const StatsLoadSuccess(this.readingCount, this.toReadCount, this.readCount);

  final int readingCount;
  final int toReadCount;
  final int readCount;

  @override
  List<Object> get props => [readingCount, toReadCount, readCount];

  int countByType(String type) {
    int count;
    switch (type) {
      case 'READING':
        count = readingCount;
        break;
      case 'TO_READ':
        count = toReadCount;
        break;
      case 'READ':
        count = readCount;
        break;
    }
    return count ?? 0;
  }

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'StatsLoadSuccess { readingCount: $readingCount, toReadCount: $toReadCount, readCount: $readCount }';
  }
}
