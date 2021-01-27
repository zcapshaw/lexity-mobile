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
      this.sourceTwitterScreenName,
      this.sourceImg,
      this.sourceId,
      this.sourceTwitterId,
      this.sourceTwitterVerified});

  final String id;
  String comment;
  final int created;
  final String sourceName;
  final String sourceTwitterScreenName;
  final String sourceImg;
  final String sourceId;
  final int sourceTwitterId;
  final bool sourceTwitterVerified;

  bool get isReco => sourceName != null;

  @override
  List<Object> get props => [id, sourceName, sourceId];

  @override
  String toString() => 'Note: ${toJson()}';

  // ignore: sort_constructors_first
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
