part of 'notes_cubit.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];

  List<SelectableNote> get notes => null;
  int get selectedCount => null;
}

class NotesInitial extends NotesState {}

class NotesLoaded extends NotesState {
  const NotesLoaded(this.notes, this.selectedCount);

  @override
  final List<SelectableNote> notes;
  @override
  final int selectedCount;

  @override
  List<Object> get props => [notes];
}
