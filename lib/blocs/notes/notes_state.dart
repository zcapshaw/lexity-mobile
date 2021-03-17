part of 'notes_cubit.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];

  List<SelectableNote> get notes => null;
  int get selectedCount => 0;
  List<String> get tweets => null;
}

class NotesInitial extends NotesState {}

class NotesLoaded extends NotesState {
  const NotesLoaded(this.notes, this.tweets, this.selectedCount);

  @override
  final List<SelectableNote> notes;
  @override
  final int selectedCount;
  @override
  final List<String> tweets;

  @override
  List<Object> get props => [notes];
}
