import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/components/book_list_bloc.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:lexity_mobile/repositories/authentication_repository.dart';
import 'package:lexity_mobile/repositories/user_repository.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockBookListBloc extends Mock implements BookListBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  var user = User();
  AuthenticationRepository authenticationRepository;
  UserRepository userRepository;
  BookListBloc bookListBloc;
  Uri uri;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    userRepository = MockUserRepository();
    bookListBloc = MockBookListBloc();
    when(userRepository.checkForCachedUser())
        .thenAnswer((_) => Future(() => false));
  });

  group('AuthenticationBloc', () {
    test('throws when authenticationRepository is null', () {
      expect(
        () => AuthenticationBloc(
          authenticationRepository: null,
          userRepository: userRepository,
        ),
        throwsAssertionError,
      );
    });

    test('throws when userRepository is null', () {
      expect(
        () => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: null,
        ),
        throwsAssertionError,
      );
    });

    test('initial state is AuthenticationState', () {
      final authenticationBloc = AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      );
      expect(authenticationBloc.state, const AuthenticationUnknown());
      authenticationBloc.close();
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [Unauthenticated] when user Logs Out',
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(const LoggedOut()),
      expect: const <AuthenticationState>[Unauthenticated()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits correct sequence of states when tapping login via twitter',
      build: () => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(const LogInWithTwitter()),
      expect: const <AuthenticationState>[
        AuthenticationLoading(),
        Unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [Authenticated] when login successful',
      build: () {
        when(userRepository.getLexityUserFromUri(uri))
            .thenAnswer((_) => Future(() => true));
        return AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        );
      },
      act: (bloc) => bloc.add(InboundUriLinkReceived(uri)),
      expect: <AuthenticationState>[Authenticated(user)],
    );
  });
}
