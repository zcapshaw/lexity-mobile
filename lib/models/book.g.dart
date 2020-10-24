//ignore_for_file: implicit_dynamic_parameter
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
    imageLinks: (json['imageLinks'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
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

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'authors': instance.authors,
      'imageLinks': instance.imageLinks,
      'googleId': instance.googleId,
      'description': instance.description,
      'categories': instance.categories,
      'listId': instance.listId,
      'type': instance.type,
      'recos': instance.recos,
      'inUserList': instance.inUserList,
      'userRead': instance.userRead,
    };
