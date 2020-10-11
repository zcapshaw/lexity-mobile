import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lexity_mobile/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:lexity_mobile/repositories/user_repository.dart';
import 'package:lexity_mobile/theme.dart';
import 'package:provider/provider.dart';

import 'package:lexity_mobile/blocs/simple_bloc_observer.dart';
import 'package:lexity_mobile/services/list_service.dart';

import 'blocs/blocs.dart';
import 'models/user.dart';
import 'screens/screens.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => ListService());
}

Future main() async {
  Bloc.observer = SimpleBlocObserver();
  setupLocator();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserRepository(),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookDetailsCubit>(
          create: (context) => BookDetailsCubit(),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
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
              print('state is Authenticated');
              _navigator.pushAndRemoveUntil<void>(
                MainScreen.route(),
                (route) => false,
              );
            }
            if (state is Unauthenticated) {
              print('state is Unauthenticated');
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
