import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import './models.dart';

part 'listed_book.g.dart';

@JsonSerializable(includeIfNull: false)
class ListedBook extends Book with EquatableMixin {
  ListedBook(
      {String
          title, // TODO: See if this test to instantiate worked - if so, apply elsewhere
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
      this.notes,
      this.created,
      this.updated})
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

  //final String title;
  final String subtitle;
  final List authors;
  final String cover;
  final String googleId;
  final String description;
  final List<String> categories;
  final String listId;
  final String userId;
  final String bookId;
  final bool inUserList;
  final bool userRead;
  final int created;
  int updated;
  String type;
  List<Note> recos;
  List labels;
  List<Note> notes;

  @override
  List<Object> get props => [bookId, type, notes, recos, labels];

  @override
  String toString() => 'ListedBook: ${toJson()}';

  bool get toRead => type == 'TO_READ';
  bool get reading => type == 'READING';
  bool get read => type == 'READ';
  List<String> get recoSourceNames =>
      recos.map((reco) => reco?.sourceName).toList();

  set changeType(String newType) => type = newType;
  set updatedAt(int updatedDateTime) => updated = updatedDateTime;
  set addAllNotes(List<Note> oldNotes) => notes.addAll(oldNotes);
  set addAndDeduplicateRecos(List<Note> oldRecos) =>
      recos.addAll(List<Note>.from(oldRecos
        ..removeWhere((reco) => recoSourceNames.contains(reco.sourceName))));

  ListedBook clone() {
    return ListedBook(
        title: title,
        subtitle: subtitle,
        authors: authors,
        cover: cover,
        googleId: googleId,
        description: description,
        categories: categories,
        listId: listId,
        userId: userId,
        bookId: bookId,
        type: type,
        inUserList: inUserList,
        userRead: userRead,
        recos: recos,
        labels: labels,
        notes: notes);
  }

  // ignore: sort_constructors_first
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

    writeNotNull('userId', userId);
    writeNotNull('bookId', bookId);
    writeNotNull('type', type);
    writeNotNull('labels', labels);
    writeNotNull('notes', notes);
    writeNotNull('updated', updated);
    return val;
  }
}

class ListedBookHeader extends ListedBook {
  ListedBookHeader(String type) : super(type: type);
}
