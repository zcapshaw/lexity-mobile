import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable(
  nullable: true,
  includeIfNull: false,
)
class Note {
  Note({this.comment, this.created, this.sourceName, this.sourceId, this.id});

  String comment;
  int created;
  String sourceName;
  String sourceId;
  String id;

  bool get isReco {
    return this.sourceName == null;
  }

  // Note.id is assigned by the backend, therefore
  // newly instantiated notes have no id
  bool get newNote {
    return this.id == null;
  }

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
