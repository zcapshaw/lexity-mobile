import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:lexity_mobile/models/models.dart';

abstract class ReadingListEvent extends Equatable {
  const ReadingListEvent();

  @override
  List<Object> get props => [];
}

class ReadingListLoaded extends ReadingListEvent {}

class ReadingListRefreshed extends ReadingListEvent {}

class ReadingListAdded extends ReadingListEvent {
  final ListedBook book;

  const ReadingListAdded(this.book);

  @override
  List<Object> get props => [book];

  @override
  String toString() => 'ReadingListAdded { book: $book }';
}

class ReadingListReordered extends ReadingListEvent {
  final int oldIndex;
  final int newIndex;
  final bool isHomescreen;

  const ReadingListReordered(this.oldIndex, this.newIndex,
      {this.isHomescreen = false});

  @override
  List<Object> get props => [oldIndex, newIndex];

  @override
  String toString() =>
      'ReadingListReordered { oldIndex: $oldIndex, newIndex: $newIndex, isHomescreen: $isHomescreen }';
}

class ReadingListDeleted extends ReadingListEvent {
  final ListedBook book;

  const ReadingListDeleted(this.book);

  @override
  List<Object> get props => [book];

  @override
  String toString() => 'ReadingListDeleted { book: $book }';
}
