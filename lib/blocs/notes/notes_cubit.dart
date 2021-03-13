import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lexity_mobile/models/models.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  void loadNotes(List<Note> notes) {
    var notesArray = <String>[];

    //remove the recos from the array
    var notesWithoutRecos = List<Note>.from(notes)
      ..removeWhere((n) => n.isReco == true);

    //convert notes to plain text array
    for (var note in notesWithoutRecos) {
      notesArray.add(note.comment);
    }

    // emit state with plain text notes array for UI
    emit(NotesLoaded(notesArray));
  }
}
