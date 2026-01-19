import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF136DEC);
  static const Color backgroundLight = Color(0xFFF6F7F8);
  static const Color backgroundDark = Color(0xFF101822);
  static const Color cardDark = Color(0xFF1E2229);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A); // slate-900
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0xFF64748B); // slate-500
  static const Color textSecondaryDark = Color(0xFF94A3B8); // slate-400

  // Level Up / Celebration Colors
  static const Color goldLight = Color(0xFFFDE68A);
  static const Color gold = Color(0xFFF59E0B);
  static const Color goldDark = Color(0xFFB45309);
  static const Color royalPurple = Color(0xFF6B21A8);
  static const Color deepNavy = Color(0xFF0F172A);
  static const Color primaryGold =
      Color(0xFFFFD700); // The bright yellow/gold used in texts

  static const Color accentGreen =
      Color(0xFF34D399); // emerald-400 equivalent for charts

  // Stack Builder Colors
  static const Color surfaceDark = Color(0xFF1C2027);
  static const Color surfaceHighlight = Color(0xFF282F39);
  static const Color textSecondaryBlue = Color(0xFF9DA8B9);

  // Daily Stack Forest Theme
  static const Color forestGreen = Color(0xFF102217);
  static const Color brightGreen = Color(0xFF13EC6A);
  static const Color cardForest = Color(0xFF1C2720);
  static const Color accentPurple = Color(0xFFA78BFA);

  // Streak Saved Theme
  static const Color streakBlue = Color(0xFF136DEC);

  // Streak Recovery Theme
  static const Color primaryOrange = Color(0xFFEE8C2B);
  static const Color backgroundDarkBrown = Color(0xFF221910);

  // Onboarding Theme
  static const Color freshGreen = Color(0xFF4CE680);

  // Warning/Safety Colors
  static const Color warningAmber = Color(0xFFFFC107);
  static const Color warningAmberDark = Color(0xFFB45309);
  static const Color warningAmberBgLight = Color(0xFFFFF7ED); // amber-50
  static const Color warningAmberBgDark = Color(0xFF451A03); // amber-900 like
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.cardLight,
        onSurface: AppColors.textPrimaryLight,
      ),
      textTheme: GoogleFonts.lexendTextTheme().apply(
        bodyColor: AppColors.textPrimaryLight,
        displayColor: AppColors.textPrimaryLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.cardDark,
        onSurface: AppColors.textPrimaryDark,
      ),
      textTheme: GoogleFonts.lexendTextTheme().apply(
        bodyColor: AppColors.textPrimaryDark,
        displayColor: AppColors.textPrimaryDark,
      ),
    );
  }
}
