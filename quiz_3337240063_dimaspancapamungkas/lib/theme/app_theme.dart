import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF3ECDD);
  static const Color surface = Color(0xFFFBF6EA);
  static const Color primary = Color(0xFF1F3B2D);
  static const Color primaryDark = Color(0xFF152A20);
  static const Color accent = Color(0xFFD9683F);
  static const Color ink = Color(0xFF141414);
  static const Color muted = Color(0xFF7C7466);
  static const Color divider = Color(0xFFD9CFB8);
  static const Color error = Color(0xFFB33A3A);
}

class AppRadius {
  static const double small = 6;
  static const double medium = 10;
  static const double large = 18;
}

class AppSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppTheme {
  static const String _primaryFont = 'Georgia';
  static const String _bodyFont = 'Helvetica';

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: _primaryFont,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        height: 1.1,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontFamily: _primaryFont,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        height: 1.15,
        letterSpacing: -0.3,
      ),
      titleLarge: TextStyle(
        fontFamily: _primaryFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      bodyLarge: TextStyle(
        fontFamily: _bodyFont,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
        height: 1.4,
      ),
      bodyMedium: TextStyle(
        fontFamily: _bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontFamily: _bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: AppColors.ink,
      ),
      labelSmall: TextStyle(
        fontFamily: _bodyFont,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: AppColors.muted,
      ),
    );
  }

  static ThemeData light() {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.surface,
        onSecondary: AppColors.surface,
        onSurface: AppColors.ink,
      ),
      textTheme: _buildTextTheme(),
      dividerColor: AppColors.divider,
    );
  }
}
