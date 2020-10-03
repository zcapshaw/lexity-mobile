class Book {
  final String title;
  final String subtitle;
  final List authors;
  final String thumbnail;
  final String googleId;
  final String description;
  final String genre;
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
      this.genre,
      this.listId,
      this.type,
      this.recos,
      this.inUserList,
      this.userRead});

  //returns the complete list of authors as a comma-separated string
  String get authorsAsString => this.authors.join(', ');

  String get titleWithSubtitle {
    String title = this.title;
    if (this.subtitle != null && this.subtitle != '')
      title = '$title: ${this.subtitle}';
    return title;
  }
}
