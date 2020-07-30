import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lexity_mobile/screens/book_search_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await DotEnv().load('.env');
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
        home: MyHome(),
        theme: ThemeData(
          primarySwatch: Colors.teal,
          appBarTheme: AppBarTheme(
              color: Colors.grey[200],
              brightness: Brightness.light,
              iconTheme: IconThemeData(
                color: Colors.grey[700],
              )),
          textTheme: TextTheme(
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
            ),
            bodyText1: GoogleFonts.roboto(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
              letterSpacing: 0.75,
            ),
            bodyText2: GoogleFonts.roboto(
              color: Colors.grey[700],
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
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/bookSearch': (context) => BookSearchScreen(),
        });
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: true);
    print('User authenticated? ${user.authN}');
    if (!user.authN) {
      return LoginScreen();
    } else {
      return HomeScreen();
    }
  }
}
