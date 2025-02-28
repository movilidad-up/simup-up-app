import 'package:flutter/material.dart';
import 'package:simup_up/views/styles/colors.dart';

class AppThemes {
  static ThemeData _generateThemeData({
    required Color inverseSurface,
    required Color surface,
    required Color surfaceContainerHighest,
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color surfaceContainer,
    required Color surfaceContainerHigh,
    required Color outline,
    required Color primary,
    required Color onPrimary,
    required Color onPrimaryContainer,
    required Color secondary,
    required Color tertiary,
    required Color onTertiary,
    required Color onTertiaryContainer,
    required Brightness brightness,
  }) {
    return ThemeData(
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: onSurface),
        displayMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: onSurface),
        displaySmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: tertiary,
            height: 1.6
        ),
        headlineMedium: TextStyle(
            fontFamily: 'Inter',
            color: onSurface,
            fontSize: 16.0,
            fontWeight: FontWeight.w600
        ),
        headlineSmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: tertiary
        ),
        titleSmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: onSurface,
        ),
        bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: tertiary,
            height: 1.4
        ),
        bodySmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: tertiary,
            height: 1.4
        ),
        labelLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: tertiary
        ),
        labelMedium: TextStyle(
          fontFamily: 'Inter',
          letterSpacing: 0.5,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: surface,
        ),
        labelSmall: TextStyle(
            fontFamily: 'Inter',
            letterSpacing: 0.2,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: tertiary
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        inverseSurface: inverseSurface,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        surfaceContainerHighest: surfaceContainerHighest,
        surfaceContainer: surfaceContainer, // surface
        surfaceContainerHigh: surfaceContainerHigh, // onSurface
        outline: outline,
        primary: primary,
        onPrimary: onPrimary,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        tertiary: tertiary,
        onTertiary: onTertiary,
        onTertiaryContainer: onTertiaryContainer,
        seedColor: AppColors.bgDark,
        brightness: brightness,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData defaultLight = _generateThemeData(
    primary: AppColors.primaryLight,
    onPrimary: AppColors.disabledPrimaryLight,
    onPrimaryContainer: AppColors.activePrimaryLight,
    secondary: AppColors.secondaryLight,
    surface: AppColors.bgLight,
    onSurface: AppColors.fgLight,
    surfaceContainer: AppColors.primarySurfaceLight,
    surfaceContainerHigh: AppColors.secondarySurfaceLight,
    onSurfaceVariant: AppColors.tertiarySurfaceLight,
    surfaceContainerHighest: AppColors.fgLight,
    inverseSurface: AppColors.transparentBackgroundLight,
    outline: AppColors.primaryOutlineLight,
    tertiary: AppColors.primaryGrayLight,
    onTertiary: AppColors.secondaryGrayLight,
    onTertiaryContainer: AppColors.tertiaryGrayLight,
    brightness: Brightness.light,
  );

  static ThemeData defaultDark = _generateThemeData(
    primary: AppColors.primaryDark,
    onPrimary: AppColors.disabledPrimaryDark,
    onPrimaryContainer: AppColors.activePrimaryDark,
    secondary: AppColors.secondaryDark,
    surface: AppColors.bgDark,
    onSurface: AppColors.fgDark,
    surfaceContainer: AppColors.primarySurfaceDark,
    surfaceContainerHigh: AppColors.secondarySurfaceDark,
    onSurfaceVariant: AppColors.tertiarySurfaceDark,
    surfaceContainerHighest: AppColors.bgDark,
    inverseSurface: AppColors.transparentBackgroundDark,
    outline: AppColors.primaryOutlineDark,
    tertiary: AppColors.primaryGrayDark,
    onTertiary: AppColors.secondaryGrayDark,
    onTertiaryContainer: AppColors.tertiaryGrayDark,
    brightness: Brightness.dark,
  );
}