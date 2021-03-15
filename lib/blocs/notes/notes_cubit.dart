import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lexity_mobile/models/models.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  void toggleSelection(SelectableNote note) {
    var updatedNote = SelectableNote(
        comment: note.comment,
        id: note.id,
        created: note.created,
        selected: !note.selected);

    var updatedNotesArray = (state as NotesLoaded).notes.map((n) {
      if (n.id == note.id) {
        return updatedNote;
      } else {
        return n;
      }
    }).toList();

    emit(NotesLoaded(
        updatedNotesArray, getSelectedNotesCount(updatedNotesArray)));
  }

  void loadNotes(List<Note> notes) {
    var selectableNotesArray = <SelectableNote>[];

    //convert notes to SelectableNotes
    for (var note in notes) {
      var sn = SelectableNote(
          comment: note.comment,
          id: note.id,
          created: note.created,
          selected: true);

      selectableNotesArray.add(sn);
    }

    // emit state with plain text notes array for UI
    emit(NotesLoaded(
        selectableNotesArray, getSelectedNotesCount(selectableNotesArray)));
  }

  int getSelectedNotesCount(List<SelectableNote> notes) {
    var selectedCount = notes.where((n) => n.selected == true).toList().length;

    return selectedCount;
  }
}
