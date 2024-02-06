import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    appBarTheme: const AppBarTheme(elevation: 0),
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      primary: Colors.black,
      secondary: Color.fromRGBO(30, 30, 30, 1),
      tertiary: Color.fromARGB(31, 162, 162, 162),
    ));

ThemeData darkMode = ThemeData(
    appBarTheme: const AppBarTheme(elevation: 0),
    colorScheme: const ColorScheme.dark(
        background: Colors.black,
        primary: Colors.white,
        secondary: Color.fromRGBO(29, 29, 29, 1)));
