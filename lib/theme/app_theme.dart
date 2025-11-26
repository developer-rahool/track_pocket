import 'package:flutter/material.dart';
import 'package:trackpocket/utiles/const.dart';

const MaterialColor mainColor = MaterialColor(0xFF002577, <int, Color>{
  50: Color(0xFFE3ECFB),
  100: Color(0xFFB9D0F7),
  200: Color(0xFF8AB3F2),
  300: Color(0xFF5B96ED),
  400: Color(0xFF3A81EA),
  500: Color(0xFF186CE7),
  600: Color(0xFF015DE0),
  700: Color(0xFF024AE6), // your main color
  800: Color(0xFF023CBC),
  900: Color(0xFF002577),
});

const Color subMainColor = Color(0xFF024AE6);

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: mainColor,
    scaffoldBackgroundColor: whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: chrome900,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: mainColor,
      unselectedItemColor: chrome600,
      backgroundColor: whiteColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: mainColor,
    ),
    textTheme: TextTheme(bodyMedium: TextStyle(color: chrome900)),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // primarySwatch:Colors.b,
    scaffoldBackgroundColor: chrome700,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: whiteColor,
      unselectedItemColor: chrome600,
      backgroundColor: chrome700,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: chrome800,
      foregroundColor: whiteColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black87,
    ),
    textTheme: TextTheme(bodyMedium: TextStyle(color: chrome900)),
  );
}
