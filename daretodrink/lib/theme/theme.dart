import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData getThemeData() {
    return ThemeData(
        brightness: Brightness.dark,
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
        ));
  }

  static const Color _primaryColor = Color.fromARGB(170, 250, 50, 50);
}
