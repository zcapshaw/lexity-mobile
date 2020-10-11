part of 'authentication_bloc.dart';

// States emitted by AuthenticationBloc
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

// Default state
class AuthenticationUnknown extends AuthenticationState {
  const AuthenticationUnknown();
}

// State when authenticated
// Informs UI to render MainScreen
class Authenticated extends AuthenticationState {
  const Authenticated();
}

// State when unauthenticated
// Informs UI to render login screen
class Unauthenticated extends AuthenticationState {
  const Unauthenticated();
}
