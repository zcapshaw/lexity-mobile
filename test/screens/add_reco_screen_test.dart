// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/components/components.dart';
import 'package:lexity_mobile/screens/screens.dart';
import 'package:mockito/mockito.dart';

import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/services/services.dart';
import 'package:lexity_mobile/models/listed_book.dart';
import 'package:lexity_mobile/models/note.dart';
import 'package:lexity_mobile/models/user.dart';
import 'package:lexity_mobile/utils/test_keys.dart';

class MockAuthenticationBoc extends MockBloc<AuthenticationState>
    implements AuthenticationBloc {}

class MockReadingListBloc extends MockBloc<ReadingListState>
    implements ReadingListBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockListService extends Mock implements ListService {}

void main() {
  AuthenticationBloc authenticationBloc;
  ListService listService;
  var user = User();
  var query = 'Super Cool User';
  var twitterResults = const APIResponse(data: [
    {
      'twitter_id': 69094173,
      'name': 'Zach Capshaw',
      'screen_name': 'zachcapshaw',
      'profile_image_url_https':
          'https://pbs.twimg.com/profile_images/966444344344391681/0hVBKU3i_normal.jpg',
      'following': true,
      'verified': false
    }
  ]);

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    authenticationBloc = MockAuthenticationBoc();
    listService = MockListService();
    when(authenticationBloc.state).thenReturn(Authenticated(user));
    when(listService.searchTwitterUsers(any, any, any))
        // .thenReturn(Future.value(twitterResults));
        .thenAnswer((_) async => twitterResults);
  });

  tearDown(() {
    authenticationBloc.close();
  });

  group('AddRecoScreen', () {
    testWidgets('Add reco screen renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authenticationBloc,
            child: const AddRecoScreen(
              recoText: 'Testing 1, 2',
            ),
          ),
        ),
      );

      expect(find.text('Testing 1, 2'), findsOneWidget);
      expect(find.byType(TextFieldTile), findsNWidgets(2));
    });

    testWidgets('Tapping Done pops navigation to AddBookScreen',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          home: BlocProvider.value(
            value: authenticationBloc,
            child: const AddRecoScreen(
              recoSource: '',
              recoText: '',
            ),
          ),
        ),
      );

      expect(find.byType(FlatButton), findsOneWidget);
      await tester.tap(find.byType(FlatButton));
      await tester.pumpAndSettle();

      //verify that tapping the cancel button triggers a Navigation.pop event
      verify(mockObserver.didPop(any, any));
    });

    testWidgets(
        'Tapping Done when recoSource.isEmpty && recoText.isNotEmpty throws Snackbar error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: authenticationBloc,
            child: const AddRecoScreen(
              recoSource: '',
              recoText: 'Text without reco - this is a no no!',
            ),
          ),
        ),
      );

      expect(find.byType(FlatButton), findsOneWidget);
      await tester.tap(find.byType(FlatButton));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Reco notes require a source.'), findsOneWidget);
    });
  });
}
