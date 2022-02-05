import 'package:flutter/material.dart';

const Color themeColor = Color(0xFF004282); //0A6889

ThemeData lightThemeData = ThemeData(
  primaryColor: Colors.blue,
  brightness: Brightness.light,
  backgroundColor: themeColor,
  appBarTheme: const AppBarTheme(backgroundColor: themeColor),
  focusColor: Colors.teal,
  unselectedWidgetColor: Colors.teal,
  splashColor: Colors.blueGrey,
  scaffoldBackgroundColor: const Color(0xFFFFF9F9),
  textTheme: TextTheme(
    button: const TextStyle(color: Colors.white70),
    subtitle1: const TextStyle(color: Colors.cyan),
    subtitle2: const TextStyle(color: Colors.red),
    headline6: TextStyle(
      color: Colors.yellow,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.blue[700]!,
    ),
    headline5: const TextStyle(color: Colors.blue),
    headline4: const TextStyle(color: Colors.deepOrange),
    headline3: const TextStyle(color: Colors.black87),
    overline: const TextStyle(color: Colors.white),
    headline2: const TextStyle(color: Colors.yellowAccent),
    headline1: const TextStyle(color: Colors.indigo),
    caption: const TextStyle(color: Colors.limeAccent),
    bodyText2: const TextStyle(color: Colors.lightGreenAccent, fontSize: 30),
    bodyText1: const TextStyle(color: Colors.indigo),
  ),
);

ThemeData darkThemeData = ThemeData(
  primaryColor: Colors.blue,
  textTheme: const TextTheme(button: TextStyle(color: Colors.black54)),
  brightness: Brightness.dark,
  backgroundColor: themeColor,
  appBarTheme: const AppBarTheme(backgroundColor: themeColor),
  focusColor: Colors.teal,
  unselectedWidgetColor: Colors.teal,
  splashColor: Colors.teal,
  scaffoldBackgroundColor: const Color(0xFFFFF9F9),
  cardColor: Colors.teal,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
      .copyWith(secondary: Colors.teal),
);
