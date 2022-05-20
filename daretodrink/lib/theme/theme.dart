import 'package:daretodrink/data/application-properties.dart';
import 'package:daretodrink/globals.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData getThemeData() {
    return ThemeData(
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
                  const TextStyle(
                      color: Color.fromARGB(170, 250, 50, 50), fontSize: 18)),
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
        listTileTheme: ListTileThemeData(
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: _primaryColor),
                borderRadius: ApplicationProperties.instance.borderRadius)));
  }

  static const Color _primaryColor = Color.fromARGB(170, 250, 50, 50);
}
