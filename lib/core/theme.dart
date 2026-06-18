import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1E40AF);
  static const accent = Color(0xFFF59E0B);
  static const accentDark = Color(0xFFD97706);
  static const bg = Color(0xFFF8F9FF);
  static const textPrimary = Color(0xFF0D1C2E);
  static const textSecondary = Color(0xFF757684);
  static const border = Color(0xFFC4C5D5);
}

class AppTypography {
  static const font = 'IBM Plex Sans Arabic';
  static const xs = 14.0;
  static const sm = 16.0;
  static const md = 17.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 26.0;
}

class AppTheme {
  static ThemeData get light {
    const textTheme = TextTheme(
      headlineLarge: TextStyle(
        fontFamily: AppTypography.font,
        fontSize: AppTypography.xxl,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppTypography.font,
        fontSize: AppTypography.xl,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: AppTypography.font,
        fontSize: AppTypography.lg,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: AppTypography.font,
        fontSize: AppTypography.md,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppTypography.font,
        fontSize: AppTypography.md,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppTypography.font,
        fontSize: AppTypography.sm,
        color: AppColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontFamily: AppTypography.font,
        fontSize: AppTypography.xs,
        color: AppColors.textSecondary,
      ),
      labelLarge: TextStyle(
        fontFamily: AppTypography.font,
        fontSize: AppTypography.md,
        fontWeight: FontWeight.w600,
      ),
    );

    return ThemeData(
      fontFamily: AppTypography.font,
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.font,
          fontSize: AppTypography.lg,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(
          fontFamily: AppTypography.font,
          fontSize: AppTypography.sm,
        ),
        hintStyle: const TextStyle(
          fontFamily: AppTypography.font,
          fontSize: AppTypography.sm,
          color: AppColors.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: AppTypography.font,
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: AppTypography.font,
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: AppTypography.font,
            fontSize: AppTypography.sm,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      useMaterial3: true,
    );
  }
}
