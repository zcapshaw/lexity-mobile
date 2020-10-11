import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationUnknown()) {
    _checkForLoggedInUser();
  }

  // TODO: add userRepository as a dependency here
  // TODO: dispose of repo

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is LoggedIn) {
      yield const Authenticated();
    }
    if (event is LoggedOut) {
      yield const Unauthenticated();
    }
  }

  Future<void> _checkForLoggedInUser() async {
    await Future.delayed(const Duration(seconds: 1));
    print('invoked');
    add(const LoggedIn());
  }
}
