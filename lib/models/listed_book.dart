import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import './models.dart';

part 'listed_book.g.dart';

@JsonSerializable(includeIfNull: false)
class ListedBook extends Book with EquatableMixin {
  ListedBook(
      {String title,
      String subtitle,
      List authors,
      this.cover,
      String googleId,
      String description,
      List<String> categories,
      String listId,
      String isbn,
      String googleLink,
      this.userId,
      this.bookId,
      this.prev,
      this.next,
      String type,
      bool inUserList,
      bool userRead,
      List<Note> recos,
      this.labels,
      this.notes,
      this.created,
      this.updated})
      : super(
          title: title,
          subtitle: subtitle,
          authors: authors,
          googleId: googleId,
          description: description,
          categories: categories,
          listId: listId,
          isbn: isbn,
          googleLink: googleLink,
          type: type,
          recos: recos,
          inUserList: inUserList,
          userRead: userRead,
        );

  final String cover;
  final String userId;
  final String bookId;
  final int created;
  String prev;
  String next;
  int updated;
  List labels;
  List<Note> notes;

  @override
  List<Object> get props => [bookId, type, notes, recos, labels, prev, next];

  @override
  String toString() => 'ListedBook: ${toJson()}';

  bool get toRead => type == 'TO_READ';
  bool get reading => type == 'READING';
  bool get read => type == 'READ';
  List<String> get recoSourceNames =>
      recos.map((reco) => reco?.sourceName).toList();
  String get uriEncodedTitle => Uri.encodeFull('$title: $subtitle');

  set changeType(String newType) => type = newType;
  set updatedAt(int updatedDateTime) => updated = updatedDateTime;
  set addAllNotes(List<Note> oldNotes) => notes.addAll(oldNotes);
  set addAndDeduplicateRecos(List<Note> oldRecos) =>
      recos.addAll(List<Note>.from(oldRecos
        ..removeWhere((reco) => recoSourceNames.contains(reco.sourceName))));

  ListedBook clone({String prev, String next}) {
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
        prev: prev ?? this.prev, // allow overriding in clone, helpful in tests
        next: next ?? this.next, // allow overriding in clone, helpful in tests
        type: type,
        inUserList: inUserList,
        userRead: userRead,
        recos: recos,
        labels: labels,
        notes: notes);
  }

  ListedBook linkListOnly() {
    return ListedBook(userId: userId, bookId: bookId, prev: prev, next: next);
  }

  // ignore: sort_constructors_first
  factory ListedBook.fromJson(Map<String, dynamic> json) =>
      _$ListedBookFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ListedBookToJson(this);

  /// Custom json serialization, to isolate only variables used on the backend
  /// for the LIST vertice. Several other ListedBook inherited values
  /// (e.g. Title, Authors) belong to the Books node
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
    writeNotNull('prev', prev);
    writeNotNull('next', next);
    return val;
  }
}

class ListedBookHeader extends ListedBook {
  ListedBookHeader(String type) : super(type: type);
}
