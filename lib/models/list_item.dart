import 'package:json_annotation/json_annotation.dart';

part 'list_item.g.dart';

@JsonSerializable()
class ListItem {
  ListItem({this.userId, this.bookId, this.type, this.labels, this.notes});

  String userId;
  String bookId;
  String type;
  List labels;
  List notes;

  Map<String, dynamic> toJson() => _$ListItemToJson(this);
}
