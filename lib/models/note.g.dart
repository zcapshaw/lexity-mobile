// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) {
  return Note(
    comment: json['comment'] as String,
    created: json['created'] as int,
  );
}

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'comment': instance.comment,
      'created': instance.created,
    };
