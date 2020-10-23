import 'package:json_annotation/json_annotation.dart';

import './models.dart';

part 'book.g.dart';

@JsonSerializable(
  nullable: true,
  includeIfNull: false,
)
class Book {
  Book(
      {this.title,
      this.subtitle,
      this.authors,
      this.thumbnail,
      this.googleId,
      this.description,
      this.categories,
      this.listId,
      this.type,
      this.recos,
      this.inUserList,
      this.userRead});

  final String title;
  final String subtitle;
  final List authors;
  final String thumbnail;
  final String googleId;
  final String description;
  final List<String> categories;
  final String listId;
  final String type;
  final List<Note> recos;
  final bool inUserList;
  final bool userRead;

  //returns the complete list of authors as a comma-separated string
  String get authorsAsString => authors.join(', ');

  //returns the first genre in the array, if present
  String get primaryGenre {
    if (categories == null) {
      return '';
    } else if (categories.isEmpty) {
      return '';
    } else {
      return categories.first;
    }
  }

  //returns title: subtitle if a subtitle exists and isn't empty
  String get titleWithSubtitle {
    var title = this.title;
    if (subtitle != null && subtitle.isNotEmpty) title = '$title: $subtitle';
    return title;
  }

  // ignore: sort_constructors_first
  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);
}
