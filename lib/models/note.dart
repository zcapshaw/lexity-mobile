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

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
