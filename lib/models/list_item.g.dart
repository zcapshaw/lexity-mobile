// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListItem _$ListItemFromJson(Map<String, dynamic> json) {
  return ListItem(
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    authors: json['authors'] as List,
    cover: json['cover'] as String,
    listId: json['listId'] as String,
    userId: json['userId'] as String,
    bookId: json['bookId'] as String,
    type: json['type'] as String,
    recos: json['recos'] as List,
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

  writeNotNull('title', instance.title);
  writeNotNull('subtitle', instance.subtitle);
  writeNotNull('authors', instance.authors);
  writeNotNull('cover', instance.cover);
  writeNotNull('listId', instance.listId);
  writeNotNull('userId', instance.userId);
  writeNotNull('bookId', instance.bookId);
  writeNotNull('type', instance.type);
  writeNotNull('recos', instance.recos);
  writeNotNull('labels', instance.labels);
  writeNotNull('notes', instance.notes);
  return val;
}
