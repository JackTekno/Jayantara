import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData cyberSecurityTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
  textTheme: GoogleFonts.orbitronTextTheme().apply(bodyColor: Colors.greenAccent),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black87, foregroundColor: Colors.greenAccent),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.greenAccent,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
