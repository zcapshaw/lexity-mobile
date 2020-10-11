import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
      create: (context) => UserModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookDetailsCubit>(
      create: (context) => BookDetailsCubit(),
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
        theme: lexityTheme,
      ),
    );
  }
}
