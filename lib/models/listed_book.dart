import 'package:json_annotation/json_annotation.dart';

import './models.dart';

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
  List<Note> recos;
  List labels;
  List<Note> notes;

  bool get toRead => type == 'TO_READ';
  bool get reading => type == 'READING';
  bool get read => type == 'READ';
  List<String> get recoSourceNames =>
      recos.map((reco) => reco?.sourceName).toList();

  set changeType(String newType) => type = newType;
  set addAllNotes(List<Note> oldNotes) => notes.addAll(oldNotes);
  set addAndDeduplicateRecos(List<Note> oldRecos) =>
      recos.addAll(List<Note>.from(oldRecos
        ..removeWhere((reco) => recoSourceNames.contains(reco.sourceName))));

  ListedBook clone() {
    return ListedBook(
        title: this.title,
        subtitle: this.subtitle,
        authors: this.authors,
        cover: this.cover,
        googleId: this.googleId,
        description: this.description,
        categories: this.categories,
        listId: this.listId,
        userId: this.userId,
        bookId: this.bookId,
        type: this.type,
        inUserList: this.inUserList,
        userRead: this.userRead,
        recos: this.recos,
        labels: this.labels,
        notes: this.notes);
  }

  factory ListedBook.fromJson(Map<String, dynamic> json) =>
      _$ListedBookFromJson(json);
  Map<String, dynamic> toJson() => _$ListedBookToJson(this);

// Custom json serialization, to isolate only variables used on the backend
// for the LIST vertice. Several other ListedBook inherited values (e.g. Title, Authors)
// belong to the Books node
  Map<String, dynamic> listElementsToJson() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('userId', this.userId);
    writeNotNull('bookId', this.bookId);
    writeNotNull('type', this.type);
    // writeNotNull('recos', this.recos); - I don't think we need this, but commenting for now
    writeNotNull('labels', this.labels);

    // only include new notes in Json, as the backend will APPEND all notes
    // passed, which would create duplicates otherwise
    writeNotNull('notes', this.notes.where((n) => n.newNote).toList());
    return val;
  }
}

class ListedBookHeader extends ListedBook {
  ListedBookHeader(String type) : super(type: type);
}
