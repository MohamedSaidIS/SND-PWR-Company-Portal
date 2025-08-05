import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xfcfcf1e8),
    primary: Color(0xFF2E2E2E), // text
    secondary: Color(0xffba5f0f), //Color(0xFF1B818E),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0x37fae9cf),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xffffffff),
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
      return const TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
    }),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1B818E),
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      height: 1.6,
      color: Color(0xFF2E2E2E),
    ),
    displayLarge: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2E2E2E),
    ),
    displayMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Color(0xFF2E2E2E),
    ),
    displaySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Color(0xFF2E2E2E),
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Color(0xFF2E2E2E),
    ),
    labelLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2E2E2E),
    ),
    labelSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color(0xfcfcf1e8),
    ),
    headlineMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2E2E2E),
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
      color: Color(0xffba5f0f),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF151515),
    primary: Color(0xFFEDEAE3), // text
    secondary: Color(0xffd55c23),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF151515),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF555454),
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
