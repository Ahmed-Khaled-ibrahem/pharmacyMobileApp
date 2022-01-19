import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'const_colors.dart';

ThemeData lightThemeData = ThemeData(
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


