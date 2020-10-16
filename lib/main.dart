import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import './blocs/blocs.dart';
import './blocs/simple_bloc_observer.dart';
import './repositories/repositories.dart';
import './screens/screens.dart';
import './services/list_service.dart';
import './theme.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  GetIt.I.registerLazySingleton(() => ListService());
  runApp(BlocProvider(
      lazy: false, // load BLoC immediately
      create: (context) {
        return AuthenticationBloc(
            authenticationRepository: AuthenticationRepository(),
            userRepository: UserRepository())
          ..add(const AppStarted());
      },
      child: const App()));
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReadingListBloc>(
          create: (context) => ReadingListBloc(
            listRepository: ListRepository(),
          ),
        ),
        BlocProvider<BookDetailsCubit>(
          create: (context) => BookDetailsCubit(),
        ),
        BlocProvider<StatsCubit>(
          lazy: false, // load cubit immediately, for list header counts
          create: (context) => StatsCubit(
            readingListBloc: BlocProvider.of<ReadingListBloc>(context),
          ),
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
              context
                  .bloc<ReadingListBloc>()
                  .add(ReadingListLoaded(state.user));
              _navigator.pushAndRemoveUntil<void>(
                MainScreen.route(),
                (route) => false,
              );
            }
            if (state is Unauthenticated) {
              context.bloc<ReadingListBloc>().add(ReadingListDismount());
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
