import 'package:daretodrink/data/application-properties.dart';
import 'package:daretodrink/globals.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData getThemeData() {
    return ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
            headline4: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                  const TextStyle(color: Color.fromARGB(170, 250, 50, 50))),
              foregroundColor:
                  MaterialStateProperty.resolveWith((states) => _primaryColor),
              side: MaterialStateProperty.resolveWith(
                (states) => const BorderSide(
                  color: _primaryColor,
                ),
              )),
        ),
        listTileTheme: ListTileThemeData(
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: _primaryColor),
                borderRadius: applicationProperties.borderRadius)));
  }

  static const Color _primaryColor = Color.fromARGB(170, 250, 50, 50);
}
