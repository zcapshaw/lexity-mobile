part of 'authentication_bloc.dart';

// Base class for events fired by AuthenticationBloc
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

// User has logged in
class LoggedIn extends AuthenticationEvent {
  const LoggedIn();
}

// User has logged out
class LoggedOut extends AuthenticationEvent {
  const LoggedOut();
}
