import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable(
  nullable: true,
  includeIfNull: false,
)
class Note extends Equatable {
  Note(
      {this.id,
      this.comment,
      this.created,
      this.sourceName,
      this.sourceImg,
      this.sourceId});

  String id;
  String comment;
  int created;
  String sourceName;
  String sourceImg;
  String sourceId;

  bool get isReco => sourceName != null;

  @override
  List<Object> get props => [id, sourceName, sourceId];

  @override
  String toString() => 'Note: ${toJson()}';

  // Note.id is assigned by the backend, therefore
  // newly instantiated notes have no id
  bool get newNote => id == null;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
