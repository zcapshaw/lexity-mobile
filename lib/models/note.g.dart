// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) {
  return Note(
    id: json['id'] as String,
    comment: json['comment'] as String,
    created: json['created'] as int,
    sourceName: json['sourceName'] as String,
    sourceTwitterScreenName: json['sourceTwitterScreenName'] as String,
    sourceImg: json['sourceImg'] as String,
    sourceId: json['sourceId'] as String,
    sourceTwitterId: json['sourceTwitterId'] as int,
    sourceTwitterVerified: json['sourceTwitterVerified'] as bool,
  );
}

Map<String, dynamic> _$NoteToJson(Note instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('comment', instance.comment);
  writeNotNull('created', instance.created);
  writeNotNull('sourceName', instance.sourceName);
  writeNotNull('sourceTwitterScreenName', instance.sourceTwitterScreenName);
  writeNotNull('sourceImg', instance.sourceImg);
  writeNotNull('sourceId', instance.sourceId);
  writeNotNull('sourceTwitterId', instance.sourceTwitterId);
  writeNotNull('sourceTwitterVerified', instance.sourceTwitterVerified);
  return val;
}
