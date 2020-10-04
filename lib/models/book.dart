class Book {
  final String title;
  final String subtitle;
  final List authors;
  final String thumbnail;
  final String googleId;
  final String description;
  final List categories;
  final String listId;
  final String type;
  final List recos;
  final bool inUserList;
  final bool userRead;

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

  //returns the complete list of authors as a comma-separated string
  String get authorsAsString => this.authors.join(', ');

  //returns the first genre in the array, if present
  String get primaryGenre {
    if (this.categories == null) {
      return '';
    } else if (this.categories.isEmpty) {
      return '';
    } else {
      return this.categories.first;
    }
  }

  //returns title: subtitle if a subtitle exists
  String get titleWithSubtitle {
    String title = this.title;
    if (this.subtitle != null && this.subtitle != '')
      title = '$title: ${this.subtitle}';
    return title;
  }
}
