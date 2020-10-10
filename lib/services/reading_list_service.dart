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

  injectHeaders(List<ListedBook> readingList) {
    int readingCount =
        readingList.where((book) => book.reading).toList().length;
    int toReadCount = readingList.where((book) => book.toRead).toList().length;

    // This insertion approach assumes that the readingList types
    // will always be ordered as [READING, TO_READ, READ]
    readingList.insert(
        readingCount + toReadCount - 1, ListedBookHeader('READ'));
    readingList.insert(readingCount - 1, ListedBookHeader('TO_READ'));
    readingList.insert(0, ListedBookHeader('READING'));

    return readingList;
  }
}
