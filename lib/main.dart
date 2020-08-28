import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/book_search_screen.dart';
import 'screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/user_screen.dart';
import 'screens/splash_screen.dart';
import 'models/user.dart';
import 'services/list_service.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => ListService());
}

Future main() async {
  await DotEnv().load('.env');
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
    return MaterialApp(
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
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/splash',
        routes: {
          '/': (context) => MainScreen(),
          '/home': (context) => HomeScreen(),
          '/user': (context) => UserScreen(),
          '/login': (context) => LoginScreen(),
          '/splash': (context) => SplashScreen(),
          '/bookSearch': (context) => BookSearchScreen(),
        });
  }
}
