<<<<<<< HEAD
=======
import 'package:flutter/material.dart';
import 'package:lexity_mobile/blocs/simple_bloc_observer.dart';
import 'package:lexity_mobile/blocs/stats/stats_cubit.dart';
import 'package:lexity_mobile/services/list_service.dart';
import 'package:lexity_mobile/services/reading_list_service.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
>>>>>>> Integrate StatsCubit into MultiBlocProvider
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import './blocs/blocs.dart';
import './blocs/simple_bloc_observer.dart';
import './repositories/authentication_repository.dart';
import './repositories/user_repository.dart';
import './screens/screens.dart';
import './services/list_service.dart';
import './services/reading_list_service.dart';
import './theme.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  GetIt.I.registerLazySingleton(() => ListService());
  runApp(BlocProvider(
    lazy: false, // load BLoC immediately
    create: (context) {
      return ReadingListBloc(
        readingListService: ReadingListService(),
      )..add(ReadingListLoaded());
    },
    child: App(
      authenticationRepository: AuthenticationRepository(),
      userRepository: UserRepository(),
    ),
  ));
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
<<<<<<< HEAD
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository, userRepository: userRepository),
=======
        BlocProvider<StatsCubit>(
          lazy: false, // load cubit immediately, for list header counts
          create: (context) => StatsCubit(
            readingListBloc: BlocProvider.of<ReadingListBloc>(context),
          ),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/splash',
        routes: {
          '/': (context) => MainScreen(),
          '/home': (context) => HomeScreen(),
          '/user': (context) => UserScreen(),
          '/login': (context) => LoginScreen(),
          '/splash': (context) => SplashScreen(),
          '/bookSearch': (context) => BookSearchScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.teal,
          appBarTheme: AppBarTheme(
              color: Colors.grey[200],
              brightness: Brightness.light,
              iconTheme: IconThemeData(
                color: Colors.grey[700],
              )),
          textTheme: TextTheme(
            headline1: GoogleFonts.ibmPlexSerif(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              fontSize: 24,
            ),
            headline3: GoogleFonts.ibmPlexSerif(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            headline4: GoogleFonts.ibmPlexSerif(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A6978),
              fontSize: 36,
            ),
            headline6: GoogleFonts.roboto(
              fontWeight: FontWeight.w700,
              color: Colors.grey[700],
              fontSize: 18,
            ),
            bodyText1: GoogleFonts.roboto(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
              letterSpacing: 0.75,
            ),
            bodyText2: GoogleFonts.roboto(
              color: Colors.grey[700],
            ),
            caption: GoogleFonts.roboto(
              color: Colors.grey[400],
              fontSize: 12,
            ),
            subtitle1: GoogleFonts.roboto(
              color: Colors.grey[700],
            ),
            subtitle2: GoogleFonts.roboto(
              color: Colors.grey[600],
              fontSize: 16,
              letterSpacing: 0.4,
              height: 1.5,
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
>>>>>>> Integrate StatsCubit into MultiBlocProvider
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
