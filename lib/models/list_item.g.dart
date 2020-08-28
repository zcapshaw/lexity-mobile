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

Map<String, dynamic> _$ListItemToJson(ListItem instance) => <String, dynamic>{
      'userId': instance.userId,
      'bookId': instance.bookId,
      'type': instance.type,
      'labels': instance.labels,
      'notes': instance.notes,
    };
