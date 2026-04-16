import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppDarkColors.surface,
  colorScheme: const ColorScheme.dark(
    surface: AppDarkColors.surface,
    primary: AppDarkColors.primary, // text
    secondary: AppDarkColors.secondary,
    outline: AppDarkColors.secondary,
    onPrimaryContainer: AppDarkColors.bottomSheetBackground,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppDarkColors.surface,
    centerTitle: true,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppDarkColors.bottomSheetBackground,
  ),
  navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppDarkColors.navigatorBarBackground,
      shadowColor: AppDarkColors.navigatorBarShadow,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppDarkColors.mintColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 15,
      height: 1.6,
      color: AppDarkColors.primary,
    ),
    displayLarge: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.bold,
      color: AppDarkColors.primary,
    ),
    displayMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppDarkColors.primary,
    ),
    displaySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppDarkColors.primary,
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: AppDarkColors.primary,
    ),
    labelLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(
      fontWeight: FontWeight.w600,
      color: AppDarkColors.primary,
    ),
    labelSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppDarkColors.surface,
    ),
    headlineMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: AppDarkColors.primary,
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
      color: AppDarkColors.secondary,
    ),
  ),
);