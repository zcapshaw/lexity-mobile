// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListItem _$ListItemFromJson(Map<String, dynamic> json) {
  return ListItem(
    userId: json['userId'] as String,
    bookId: json['bookId'] as String,
    type: json['type'] as String,
    labels: json['labels'] as List,
    notes: json['notes'] as List,
  );
}

Map<String, dynamic> _$ListItemToJson(ListItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userId', instance.userId);
  writeNotNull('bookId', instance.bookId);
  writeNotNull('type', instance.type);
  writeNotNull('labels', instance.labels);
  writeNotNull('notes', instance.notes);
  return val;
}
