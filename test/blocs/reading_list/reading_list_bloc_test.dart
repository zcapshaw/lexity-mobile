import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:lexity_mobile/services/services.dart';
import 'package:lexity_mobile/repositories/repositories.dart';

class MockListRepository extends Mock implements ListRepository {}

class MockListService extends Mock implements ListService {}

// Test for every event and yielding the expected state
// Need to work out equality issues with readingList variable in state
// Deleting a book - removes it from the list, based on id
void main() {
  User user;
  ListRepository listRepository;
  ReadingListBloc readingListBloc;
  ListService listService;
  List<ListedBook> readingList;
  var listedBookOne = ListedBook(bookId: '1');
  var listedBookTwo = ListedBook(bookId: '2');

  setUp(() {
    user = User(id: 'Users/12345', accessToken: 'abc123');
    listRepository = MockListRepository();
    listService = MockListService();
    readingListBloc = ReadingListBloc(
        listRepository: listRepository, listService: listService);
    readingList = [listedBookOne, listedBookTwo];
  });

  test('initial state is ReadingListLoadInProgress', () {
    expect(readingListBloc.state, ReadingListLoadInProgress());
    readingListBloc.close();
  });

  blocTest<ReadingListBloc, ReadingListState>(
      'yields [ReadingListLoadSuccess] with ReadingListLoaded event',
      build: () => readingListBloc,
      act: (bloc) => bloc.add(ReadingListLoaded(user)),
      expect: <ReadingListState>[ReadingListLoadSuccess(readingList)]);

  blocTest<ReadingListBloc, ReadingListState>(
    'yields [ReadingListLoadInProgress] with ReadingListDismount event',
    build: () => readingListBloc,
    act: (bloc) => bloc.add(ReadingListDismount()),
    expect: <ReadingListState>[ReadingListLoadInProgress()],
  );

  // blocTest<ReadingListBloc, ReadingListState>(
  //   'yeilds [ReadingListLoadSuccess] with ReadingListAdded event',
  //   build: () {
  //     when(listRepository.addBook(newBook, readingListWithHeaders))
  //         .thenAnswer((_) => readingListAfterNewBook);
  //     when(listService.addOrUpdateListItem(user.accessToken, newBook))
  //         .thenAnswer((_) => Future.value(APIResponse(data: 'data')));
  //     return readingListBloc
  //       ..emit(ReadingListLoadSuccess(readingListWithHeaders));
  //   },
  //   act: (bloc) {
  //     bloc.add(ReadingListAdded(newBook, user));
  //   },
  //   skip: 0,
  //   expect: <ReadingListState>[ReadingListLoadSuccess(readingListAfterNewBook)],
  // );
}
