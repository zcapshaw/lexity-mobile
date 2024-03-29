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
    isbn: json['isbn'] as String,
    googleLink: json['googleLink'] as String,
    userId: json['userId'] as String,
    bookId: json['bookId'] as String,
    prev: json['prev'] as String,
    next: json['next'] as String,
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
  final val = <String, dynamic>{
    'title': instance.title,
    'subtitle': instance.subtitle,
    'authors': instance.authors,
    'googleId': instance.googleId,
    'description': instance.description,
    'categories': instance.categories,
    'listId': instance.listId,
    'isbn': instance.isbn,
    'googleLink': instance.googleLink,
    'type': instance.type,
    'recos': instance.recos,
    'inUserList': instance.inUserList,
    'userRead': instance.userRead,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cover', instance.cover);
  writeNotNull('userId', instance.userId);
  writeNotNull('bookId', instance.bookId);
  writeNotNull('created', instance.created);
  writeNotNull('prev', instance.prev);
  writeNotNull('next', instance.next);
  writeNotNull('updated', instance.updated);
  writeNotNull('labels', instance.labels);
  writeNotNull('notes', instance.notes);
  return val;
}
