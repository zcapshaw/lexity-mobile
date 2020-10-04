import 'package:json_annotation/json_annotation.dart';

import 'book.dart';
import 'note.dart';

part 'listed_book.g.dart';

@JsonSerializable(includeIfNull: false)
class ListedBook extends Book {
  ListedBook(
      {this.title,
      this.subtitle,
      this.authors,
      this.cover,
      this.googleId,
      this.description,
      this.categories,
      this.listId,
      this.userId,
      this.bookId,
      this.type,
      this.inUserList,
      this.userRead,
      this.recos,
      this.labels,
      this.notes})
      : super(
          title: title,
          subtitle: subtitle,
          authors: authors,
          thumbnail: cover,
          googleId: googleId,
          description: description,
          categories: categories,
          listId: listId,
          type: type,
          recos: recos,
          inUserList: inUserList,
          userRead: userRead,
        );

  final String title;
  final String subtitle;
  final List authors;
  final String cover;
  final String googleId;
  final String description;
  final List categories;
  final String listId;
  final String userId;
  final String bookId;
  final bool inUserList;
  final bool userRead;
  String type;
  List recos;
  List labels;
  List<Note> notes;

  set changeType(String newType) => this.type = newType;
  set mergeRecos(List newRecos) => this.recos.addAll(newRecos);

  factory ListedBook.fromJson(Map<String, dynamic> json) =>
      _$ListedBookFromJson(json);
  Map<String, dynamic> toJson() => _$ListedBookToJson(this);
}

class ListItemHeader extends ListedBook {
  ListItemHeader(String type) : super(type: type);

  String get headerType => this.type;
}
