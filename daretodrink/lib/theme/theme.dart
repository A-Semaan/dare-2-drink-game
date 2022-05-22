import 'package:daretodrink/data/application-properties.dart';
import 'package:daretodrink/globals.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData getThemeData() {
    return ThemeData(
        appBarTheme: const AppBarTheme(titleTextStyle: TextStyle(fontSize: 25)),
        primaryColor: _primaryColor,
        brightness: Brightness.dark,
        textTheme: TextTheme(
            displayLarge: const TextStyle(fontSize: 32),
            displayMedium: const TextStyle(fontSize: 22),
            displaySmall: const TextStyle(fontSize: 18),
            headlineMedium:
                const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            headlineSmall:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            titleLarge:
                const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
            titleMedium:
                const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            titleSmall:
                const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            labelLarge: const TextStyle(fontSize: 28),
            labelSmall: const TextStyle(fontSize: 22),
            bodyLarge: TextStyle(fontSize: 32, color: Colors.grey[200]),
            bodyMedium: TextStyle(fontSize: 24, color: Colors.grey[200]),
            bodySmall: TextStyle(fontSize: 16, color: Colors.grey[200])),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
          foregroundColor:
              MaterialStateProperty.resolveWith((states) => Colors.white),
          backgroundColor:
              MaterialStateProperty.resolveWith((states) => _primaryColor),
        )),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.resolveWith((states) =>
                  const TextStyle(color: _primaryColor, fontSize: 18)),
              foregroundColor:
                  MaterialStateProperty.resolveWith((states) => _primaryColor),
              side: MaterialStateProperty.resolveWith(
                (states) => const BorderSide(
                  color: _primaryColor,
                ),
              )),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
              borderRadius: ApplicationProperties.instance.borderRadius),
          color: Colors.grey[700],
          margin: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
          elevation: 2,
          clipBehavior: Clip.antiAlias,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white60,
            extendedTextStyle: TextStyle(
              fontSize: 18,
            )),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white70,
        ),
        sliderTheme: const SliderThemeData(
          valueIndicatorTextStyle: TextStyle(fontSize: 20),
          valueIndicatorColor: _primaryColor,
          activeTrackColor: _primaryColor,
          thumbColor: _primaryColor,
        ));
  }

  static const Color _primaryColor = Color.fromARGB(
      255, 7, 88, 183); //Color.fromARGB(170, 250, 50, 50); //old color theme
  static const Color secondaryColor = Color.fromARGB(255, 212, 175, 55);
}
