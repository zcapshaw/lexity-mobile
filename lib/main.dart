import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lexity_mobile/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:lexity_mobile/repositories/authentication_repository.dart';
import 'package:lexity_mobile/repositories/user_repository.dart';
import 'package:lexity_mobile/theme.dart';

import 'package:lexity_mobile/blocs/simple_bloc_observer.dart';
import 'package:lexity_mobile/services/list_service.dart';

import 'blocs/blocs.dart';
import 'screens/screens.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  GetIt.I.registerLazySingleton(() => ListService());
  runApp(
    App(
      authenticationRepository: AuthenticationRepository(),
      userRepository: UserRepository(),
    ),
  );
}

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookDetailsCubit>(
          create: (context) => BookDetailsCubit(),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
              userRepository: userRepository),
        ),
      ],
      child: AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is Authenticated) {
              _navigator.pushAndRemoveUntil<void>(
                MainScreen.route(),
                (route) => false,
              );
            }
            if (state is Unauthenticated) {
              _navigator.pushAndRemoveUntil<void>(
                LoginScreen.route(),
                (route) => false,
              );
            }
            if (state is AuthenticationLoading) {
              _navigator.pushAndRemoveUntil<void>(
                LoadingScreen.route(),
                (route) => false,
              );
            }
            if (state is AuthenticationFailed) {
              _navigator.pushAndRemoveUntil<void>(
                LoginScreen.route(),
                (route) => false,
              );
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashScreen.route(),
      routes: {
        '/': (context) => MainScreen(),
        '/home': (context) => HomeScreen(),
        '/user': (context) => UserScreen(),
        '/login': (context) => LoginScreen(),
        '/splash': (context) => SplashScreen(),
        '/bookSearch': (context) => BookSearchScreen(),
      },
      theme: lexityTheme,
    );
  }
}
