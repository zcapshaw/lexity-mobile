part of 'notes_cubit.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];

  List<String> get notes => null;
}

class NotesInitial extends NotesState {}

class NotesLoaded extends NotesState {
  const NotesLoaded(this.notes);

  @override
  final List<String> notes;

  @override
  List<Object> get props => [notes];
}
