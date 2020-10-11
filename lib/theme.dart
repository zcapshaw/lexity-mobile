import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lexityTheme = ThemeData(
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
      color: const Color(0xFF1A6978),
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
);
