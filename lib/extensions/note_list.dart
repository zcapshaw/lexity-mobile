import '../models/models.dart';

extension NoteList<T> on List<Note> {
  List<Note> get uniqueSourceName {
    var sourceNames = <String>[];
    var uniqueNotes = <Note>[];
    forEach((note) {
      if (sourceNames.contains(note.sourceName)) {
      } else {
        sourceNames.add(note.sourceName);
        uniqueNotes.add(note);
      }
    });
    return uniqueNotes;
  }
}
