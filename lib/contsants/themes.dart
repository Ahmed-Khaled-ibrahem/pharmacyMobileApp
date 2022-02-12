import 'package:flutter/material.dart';

const Color themeColor = Color(0xFF13445A); //004282
const Color themeColorBlue = Color(0xFF1989AC);
const Color themeColorGray = Color(0xFF333F44);
const Color themeColorGreen = Color(0xFFB4F1F1);
const Color themeColorWhite = Color(0xFFE5E5E5);//E5E5E5
const Color themeColorBlack = Color(0xFF393E46);//E5E5E5

ThemeData lightThemeData = ThemeData(
  primaryColor: Colors.blue,
  brightness: Brightness.light,
  backgroundColor: themeColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: themeColorBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
  ),
  focusColor: Colors.teal,
  unselectedWidgetColor: Colors.teal,
  splashColor: Colors.blueGrey,
  scaffoldBackgroundColor: const Color(0xFFFFF9F9),

  textTheme: const TextTheme(
    button: TextStyle(color: Colors.white70),
    subtitle1: TextStyle(color: Colors.cyan),
    subtitle2: TextStyle(color: Colors.red),
    headline5: TextStyle(color: Colors.blue),
    headline4: TextStyle(color: Colors.deepOrange),
    headline3: TextStyle(color: Colors.black87),
    overline: TextStyle(color: Colors.white),
    headline2: TextStyle(color: Colors.yellowAccent),
    headline1: TextStyle(color: Colors.indigo),
    caption: TextStyle(color: Colors.limeAccent),
    bodyText2: TextStyle(color: Colors.lightGreenAccent, fontSize: 30),
    bodyText1: TextStyle(color: Colors.indigo),
  ),
);

ThemeData darkThemeData = ThemeData(

  appBarTheme: const AppBarTheme(
    backgroundColor: themeColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
    centerTitle: true,
    toolbarHeight: 60,
    elevation: 0,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(themeColorBlue),
    ),
  ),

  cardTheme:  const CardTheme(
    elevation: 3,
    //shadowColor: Colors.white,
    color: themeColorGray,
    /*
    shape: RoundedRectangleBorder(
      side: const BorderSide(
          color: Colors.white70, width: 1),
      borderRadius: BorderRadius.circular(10),
    ),

     */
  ),



  textTheme: const TextTheme(
    bodyText1: TextStyle(color: themeColorGreen, fontWeight: FontWeight.bold, fontSize: 35),
    bodyText2: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 24),

    headline1: TextStyle(color: themeColorWhite,fontSize: 40),
    headline2: TextStyle(color: themeColorWhite,fontSize: 34),
    headline3: TextStyle(color: themeColorWhite,fontSize: 28),
    headline4: TextStyle(color: themeColorWhite,fontSize: 22),
    headline5: TextStyle(color: themeColorWhite,fontSize: 17),
    headline6: TextStyle(color: themeColorWhite,fontSize: 12),

    button: TextStyle(color: themeColorBlue,fontSize: 20, fontWeight: FontWeight.bold,),
    subtitle1: TextStyle(color: themeColorWhite, fontSize: 18, fontWeight: FontWeight.bold),
    subtitle2: TextStyle(color: themeColorGreen, fontSize: 18, fontWeight: FontWeight.bold),
    overline: TextStyle(color: themeColorGreen, fontWeight: FontWeight.bold, fontSize: 20),
    caption: TextStyle(color: themeColorGreen,fontWeight: FontWeight.bold, fontSize: 14),
  ),



 // buttonTheme: const ButtonThemeData(height: 50),  // color picker theme
  primaryColor: themeColor,
  brightness: Brightness.dark,
  backgroundColor: themeColor,
  focusColor: themeColor,
  unselectedWidgetColor: Colors.teal,
  splashColor: Colors.teal,
  //scaffoldBackgroundColor: const Color(0xFFFFF9F9),
);
