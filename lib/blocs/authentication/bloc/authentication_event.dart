part of 'authentication_bloc.dart';

// Base class for events fired by AuthenticationBloc
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

// Fired when the AuthenticationBloc is instantiated
class AppStarted extends AuthenticationEvent {
  const AppStarted();
}

// User taps Sign In/Up with Twitter
class LogInWithTwitter extends AuthenticationEvent {
  const LogInWithTwitter();
}

// User has logged in
class LoggedIn extends AuthenticationEvent {
  const LoggedIn();
}

// User has logged out
class LoggedOut extends AuthenticationEvent {
  const LoggedOut();
}

class InboundUriLinkReceived extends AuthenticationEvent {
  const InboundUriLinkReceived(this.uri);
  final Uri uri;
}
