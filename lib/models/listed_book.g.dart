//ignore_for_file: implicit_dynamic_parameter
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listed_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListedBook _$ListedBookFromJson(Map<String, dynamic> json) {
  return ListedBook(
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    authors: json['authors'] as List,
    cover: json['cover'] as String,
    googleId: json['googleId'] as String,
    description: json['description'] as String,
    categories: (json['categories'] as List)?.map((e) => e as String)?.toList(),
    listId: json['listId'] as String,
    userId: json['userId'] as String,
    bookId: json['bookId'] as String,
    type: json['type'] as String,
    inUserList: json['inUserList'] as bool,
    userRead: json['userRead'] as bool,
    recos: (json['recos'] as List)
        ?.map(
            (e) => e == null ? null : Note.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    labels: json['labels'] as List,
    notes: (json['notes'] as List)
        ?.map(
            (e) => e == null ? null : Note.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    created: json['created'] as int,
    updated: json['updated'] as int,
  );
}

Map<String, dynamic> _$ListedBookToJson(ListedBook instance) {
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
  writeNotNull('googleId', instance.googleId);
  writeNotNull('description', instance.description);
  writeNotNull('categories', instance.categories);
  writeNotNull('listId', instance.listId);
  writeNotNull('userId', instance.userId);
  writeNotNull('bookId', instance.bookId);
  writeNotNull('inUserList', instance.inUserList);
  writeNotNull('userRead', instance.userRead);
  writeNotNull('created', instance.created);
  writeNotNull('updated', instance.updated);
  writeNotNull('type', instance.type);
  writeNotNull('recos', instance.recos);
  writeNotNull('labels', instance.labels);
  writeNotNull('notes', instance.notes);
  return val;
}
