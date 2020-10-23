// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) {
  return Book(
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    authors: json['authors'] as List,
    thumbnail: json['thumbnail'] as String,
    googleId: json['googleId'] as String,
    description: json['description'] as String,
    categories: (json['categories'] as List)?.map((e) => e as String)?.toList(),
    listId: json['listId'] as String,
    type: json['type'] as String,
    recos: (json['recos'] as List)
        ?.map(
            (e) => e == null ? null : Note.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    inUserList: json['inUserList'] as bool,
    userRead: json['userRead'] as bool,
  );
}

Map<String, dynamic> _$BookToJson(Book instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('subtitle', instance.subtitle);
  writeNotNull('authors', instance.authors);
  writeNotNull('thumbnail', instance.thumbnail);
  writeNotNull('googleId', instance.googleId);
  writeNotNull('description', instance.description);
  writeNotNull('categories', instance.categories);
  writeNotNull('listId', instance.listId);
  writeNotNull('type', instance.type);
  writeNotNull('recos', instance.recos);
  writeNotNull('inUserList', instance.inUserList);
  writeNotNull('userRead', instance.userRead);
  return val;
}
