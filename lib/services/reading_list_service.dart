import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'list_service.dart';
import '../models/models.dart';

class ReadingListService {
  ListService get listService => GetIt.I<ListService>();

  // TODO: IMPORTANT - Using DotEnv until we can connect reading_list_bloc to the new user_bloc - this needs to be updated to be dynamic once the user_bloc is built
  final String accessToken = DotEnv().env['ACCESS_TOKEN'];
  final String userId = DotEnv().env['USER_ID'];

  loadReadingList() async {
    return await listService.getListItemSummary(accessToken, userId);
  }

  saveReadingList() async {}

  sortByTypeAndInjectHeaders(List<ListedBook> readingList) {
    List<ListedBook> sortedReadingListWithHeaders = [];
    final List<String> typeSortOrder = ['READING', 'TO_READ', 'READ'];

    typeSortOrder.forEach((type) {
      List<ListedBook> readingListByType =
          readingList.where((book) => book.type == type).toList();
      sortedReadingListWithHeaders.add(ListedBookHeader(type));
      sortedReadingListWithHeaders.addAll(readingListByType);
    });

    return sortedReadingListWithHeaders;
  }

  stripHeaders(List<ListedBook> readingList) {}
}
