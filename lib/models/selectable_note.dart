import 'package:equatable/equatable.dart';
import './models.dart';

class SelectableNote extends Note with EquatableMixin {
  bool selected;

  SelectableNote({String id, String comment, int created, this.selected})
      : super(id: id, comment: comment, created: created);

  @override
  List<Object> get props => [selected, comment, created, id];
}
