import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:lexity_mobile/repositories/repositories.dart';
import 'package:lexity_mobile/utils/utils.dart';
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
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  StreamSubscription _uriLinkStream;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      var userExists = await _userRepository.checkForCachedUser();
      if (userExists) {
        yield Authenticated(_userRepository.appUser);
      } else {
        yield const Unauthenticated();
      }
    }
    if (event is LoggedIn) {
      yield Authenticated(_userRepository.appUser);
    }
    if (event is LoggedOut) {
      yield const Unauthenticated();
    }
    if (event is LogInWithService) {
      yield const AuthenticationLoading();
      await _authenticationRepository.logInWithService(event.service);
      yield const Unauthenticated();
    }
    if (event is InboundUriLinkReceived) {
      var success = await _userRepository.getLexityUserFromUri(event.uri);
      if (success) {
        // if user successfully retreived, set state to Authenticated
        yield Authenticated(_userRepository.appUser);
        // close the logInWithService web view
        await closeWebView();
      } else {
        yield const AuthenticationFailed();
        await closeWebView();
      }
    }
  }

  @override
  Future<void> close() {
    _uriLinkStream?.cancel();
    return super.close();
  }
}
