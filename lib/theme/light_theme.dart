import 'package:company_portal/theme/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xfcfcf1e8),
  colorScheme: const ColorScheme.light(
    surface: Color(0xfcfcf1e8),
    primary: AppLightColors.primary, // text
    secondary: AppLightColors.secondary, //Color(0xFF1B818E),
    outline: AppLightColors.secondary,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xfcfcf1e8),
    centerTitle: true,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppLightColors.bottomSheetBackground,
  ),
  navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppLightColors.navigatorBarBackground,
      shadowColor: AppLightColors.navigatorBarShadow

  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppLightColors.mintColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      height: 1.6,
      color: AppLightColors.primary,
    ),
    displayLarge: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.bold,
      color: AppLightColors.primary,
    ),
    displayMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppLightColors.primary,
    ),
    displaySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppLightColors.primary,
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: AppLightColors.primary,
    ),
    labelLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppLightColors.primary,
    ),
    labelSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color(0xfcfcf1e8),
    ),
    headlineMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: AppLightColors.primary,
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
      color: AppLightColors.secondary,
    ),
  ),
);