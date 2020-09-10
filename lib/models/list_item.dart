import 'package:json_annotation/json_annotation.dart';

part 'list_item.g.dart';

@JsonSerializable(includeIfNull: false)
class ListItem {
  ListItem(
      {this.title,
      this.subtitle,
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
  final String subtitle;
  final List authors;
  final String cover;
  final String listId;
  final String userId;
  final String bookId;
  String type;
  List recos;
  List labels;
  List notes;

  String get id => this.bookId;
  String get bookListId => this.listId;
  String get bookType => this.type;
  String get bookCover => this.cover;
  String get bookTitle => this.title;
  List get bookAuthors => this.authors;
  List get bookRecos => this.recos;

  String get titleWithSubtitle {
    String title = this.title;
    if (this.subtitle != null) title = '$title: ${this.subtitle}';
    return title;
  }

  set changeType(String newType) => this.type = newType;
  set mergeRecos(List newRecos) => this.recos.addAll(newRecos);

  factory ListItem.fromJson(Map<String, dynamic> json) =>
      _$ListItemFromJson(json);
  Map<String, dynamic> toJson() => _$ListItemToJson(this);
}

class ListItemHeader extends ListItem {
  ListItemHeader(String type) : super(type: type);

  String get headerType => this.type;
}
