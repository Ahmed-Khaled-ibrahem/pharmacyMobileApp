import 'package:flutter/material.dart';

import 'const_colors.dart';

var lightThemeData = ThemeData(
    primaryColor: Colors.blue,
    textTheme: const TextTheme(button: TextStyle(color: Colors.white70)),
    brightness: Brightness.light,
  backgroundColor: themeColor,
  appBarTheme: const AppBarTheme(backgroundColor: themeColor),
  focusColor: Colors.teal,
  unselectedWidgetColor: Colors.teal,
  splashColor: Colors.blueGrey,
  scaffoldBackgroundColor: const Color(0xFFFFF9F9),

);

var darkThemeData = ThemeData(
    primaryColor: Colors.blue,
    textTheme: const TextTheme(button: TextStyle(color: Colors.black54)),
    brightness: Brightness.dark,
    backgroundColor: themeColor,
    appBarTheme: const AppBarTheme(backgroundColor: themeColor),
    focusColor: Colors.teal,
    unselectedWidgetColor: Colors.teal,
    splashColor: Colors.teal,
    scaffoldBackgroundColor: const Color(0xFFFFF9F9),
    accentColor: Colors.teal,
  buttonColor: Colors.teal,
  primarySwatch: Colors.teal,
  cardColor: Colors.teal,);