import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lexity_mobile/screens/book_search_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.teal,
          textTheme: TextTheme(
            headline3: GoogleFonts.ibmPlexSerif(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            headline6: GoogleFonts.roboto(
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
            bodyText1: GoogleFonts.roboto(
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
            bodyText2: GoogleFonts.roboto(
              color: Colors.grey[800],
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/bookSearch': (context) => BookSearchScreen(),
        });
  }
}
