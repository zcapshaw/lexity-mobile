// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_book_screen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListItem _$ListItemFromJson(Map<String, dynamic> json) {
  return ListItem(
    json['userId'] as String,
    json['bookId'] as String,
    json['type'] as String,
    (json['labels'] as List)?.map((e) => e as String)?.toList(),
    json['notes'] as List,
  );
}

Map<String, dynamic> _$ListItemToJson(ListItem instance) => <String, dynamic>{
      'userId': instance.userId,
      'bookId': instance.bookId,
      'type': instance.type,
      'labels': instance.labels,
      'notes': instance.notes,
    };
