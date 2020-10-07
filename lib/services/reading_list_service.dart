import 'list_service.dart';
import 'package:get_it/get_it.dart';

class ReadingListService {
  ListService get listService => GetIt.I<ListService>();

  loadReadingList() async {}

  saveReadingList() async {}
}
