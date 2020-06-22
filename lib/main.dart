import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
