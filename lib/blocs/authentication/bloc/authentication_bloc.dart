import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lexity_mobile/models/user.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:lexity_mobile/repositories/authentication_repository.dart';
import 'package:lexity_mobile/repositories/user_repository.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
    @required UserRepository userRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationUnknown()) {
    _uriLinkStream = getUriLinksStream().listen(
      (Uri uri) {
        add(InboundUriLinkReceived(uri));
      },
      onError: print,
    );
    _checkForLoggedInUser();
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  StreamSubscription _uriLinkStream;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is LoggedIn) {
      yield Authenticated(_userRepository.appUser);
    }
    if (event is LoggedOut) {
      yield const Unauthenticated();
    }
    if (event is LogInWithTwitter) {
      _authenticationRepository.logInWithTwitter();
      yield const AuthenticationLoading();
    }
    if (event is InboundUriLinkReceived) {
      var success = await _userRepository.getLexityUserFromUri(event.uri);
      if (success) {
        yield Authenticated(_userRepository.appUser);
        await closeWebView();
        print(_userRepository.appUser.id);
      } else {
        yield const AuthenticationFailed();
        await closeWebView();
      }
    }
  }

  Future<void> _checkForLoggedInUser() async {
    await Future.delayed(const Duration(seconds: 1));
    print('invoked');
    add(const LoggedOut());
  }

  @override
  Future<void> close() {
    _uriLinkStream?.cancel();
    return super.close();
  }
}
