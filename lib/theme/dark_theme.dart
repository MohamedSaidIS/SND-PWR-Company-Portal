import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF151515),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF151515),
    primary: Color(0xFFEDEAE3), // text
    secondary: Color(0xffd55c23),
    outline: Color(0xffd55c23),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF151515),
    centerTitle: true,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF555454),
  ),
  navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xff292929),
      shadowColor: Color(0xfff3f3f3)
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1B818E),
    ),
    bodyLarge: TextStyle(
      fontSize: 15,
      height: 1.6,
      color: Color(0xFFEDEAE3),
    ),
    displayLarge: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.bold,
      color: Color(0xFFEDEAE3),
    ),
    displayMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Color(0xFFEDEAE3),
    ),
    displaySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Color(0xFFEDEAE3),
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Color(0xFFEDEAE3),
    ),
    labelLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(
      fontWeight: FontWeight.w600,
      color: Color(0xFFEDEAE3),
    ),
    labelSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color(0xFF151515),
    ),
    headlineMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Color(0xFFEDEAE3),
    ),
    titleMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    headlineSmall: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: Color(0xffd55c23),
    ),
  ),
);