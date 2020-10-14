part of 'authentication_bloc.dart';

// States emitted by AuthenticationBloc
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];

  User get user => null;
}

// Default state
class AuthenticationUnknown extends AuthenticationState {
  const AuthenticationUnknown();
}

// State when authenticated
// Informs UI to render MainScreen
class Authenticated extends AuthenticationState {
  const Authenticated(this.user);

  @override
  final User user;
}

// State when unauthenticated
// Informs UI to render login screen
class Unauthenticated extends AuthenticationState {
  const Unauthenticated();
}

// State during Authentication async process
class AuthenticationLoading extends AuthenticationState {
  const AuthenticationLoading();
}

// State if auth attempt fails
class AuthenticationFailed extends AuthenticationState {
  const AuthenticationFailed();
}
