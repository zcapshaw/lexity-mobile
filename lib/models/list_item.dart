import 'package:json_annotation/json_annotation.dart';

part 'list_item.g.dart';

@JsonSerializable(includeIfNull: false)
class ListItem {
  ListItem(
      {this.title,
      this.authors,
      this.cover,
      this.listId,
      this.userId,
      this.bookId,
      this.type,
      this.recos,
      this.labels,
      this.notes});

  final String title;
  final List authors;
  final String cover;
  final String listId;
  final String userId;
  final String bookId;
  final String type;
  final List recos;
  final List labels;
  final List notes;

  String get bookListId {
    return this.listId;
  }

  String get bookType {
    return this.type;
  }

  String get bookCover {
    return this.cover;
  }

  String get bookTitle {
    return this.title;
  }

  List get bookAuthors {
    return this.authors;
  }

  List get bookRecos {
    return this.recos;
  }

  Map<String, dynamic> toJson() => _$ListItemToJson(this);
}
