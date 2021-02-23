import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry/sentry.dart';

import './blocs/blocs.dart';
import './blocs/simple_bloc_observer.dart';
import './repositories/repositories.dart';
import './screens/screens.dart';
import './services/list_service.dart';
import './theme.dart';
import 'dsn.dart';

// initialize Sentry for error logging
final SentryClient _sentry = SentryClient(dsn: dsn);

/// this method is used to prevent sending Sentry messages during development
bool get isInDebugMode {
  // assume we are in production mode
  var inDebugMode = false;
  // this line is only evaluated in development. It's ignored in production
  assert(inDebugMode = true);

  return inDebugMode;
}

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console.
  print('Caught error: $error');
  if (isInDebugMode) {
    // Print the full stacktrace in debug mode.
    print(stackTrace);
  } else {
    // send the error to Sentry
    print('Reporting to Sentry.io...');

    final response = await _sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );

    if (response.isSuccessful) {
      print('Success! Event ID: ${response.eventId}');
    } else {
      print('Failed to report to Sentry.io: ${response.error}');
    }
  }
}

Future<Null> main() async {
  Bloc.observer = SimpleBlocObserver();
  GetIt.I.registerLazySingleton(() => ListService());

// This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await runZonedGuarded<Future<void>>(() async {
    runApp((BlocProvider(
        lazy: false, // load BLoC immediately
        create: (context) {
          return AuthenticationBloc(
              authenticationRepository: AuthenticationRepository(),
              userRepository: UserRepository())
            ..add(const AppStarted());
        },
        child: const App())));
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
  }, _reportError);
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
            listService: ListService(),
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
      debugShowCheckedModeBanner: false,
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
