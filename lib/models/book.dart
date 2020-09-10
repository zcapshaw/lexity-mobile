class Book {
  final String title;
  final String subtitle;
  final String author;
  final String thumbnail;
  final String googleId;
  final String description;
  final String genre;
  final String listId;
  final String listType;
  final List recos;
  final bool inUserList;
  final bool userRead;

  Book(
      {this.title,
      this.subtitle,
      this.author,
      this.thumbnail,
      this.googleId,
      this.description,
      this.genre,
      this.listId,
      this.listType,
      this.recos,
      this.inUserList,
      this.userRead});

  String get bookListId => this.listId;
  String get bookType => this.listType;
  String get bookCover => this.thumbnail;
  String get bookTitle => this.title;
  String get bookSubtitle => this.subtitle;
  List get bookAuthors => [this.author];
  List get bookRecos => this.recos;
  bool get bookInUserList => this.inUserList;
  bool get userReadBook => this.userRead;
  String get titleWithSubtitle {
    String title = this.title;
    if (this.subtitle != null) title = '$title: ${this.subtitle}';
    return title;
  }
}
