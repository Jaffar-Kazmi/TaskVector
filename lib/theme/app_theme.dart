import 'package:flutter/material.dart';

class AppColors {
  static const lightPrimary = Color(0xFF0EA5E9);
  static const lightPrimaryVariant = Color(0xFF5A52D5);
  static const lightSecondary = Color(0xFF00B8D4); // Cyan Accent
  static const lightSecondaryVariant = Color(0xFF008BA3);
  static const lightTertiary = Color(0xFFFF6584); // Soft Salmon (for notifications/pop)

  static const lightBackground = Color(0xFFF8F9FD); // Very cool white
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFE2E4F0); // Slight lavender tint

  static const lightTextPrimary = Color(0xFF2D3142); // Gunmetal
  static const lightTextSecondary = Color(0xFF9094A6); // Cool Grey
  static const lightTextTertiary = Color(0xFFC4C6D0);

  static const lightDivider = Color(0xFFE6E8F0);
  static const lightBorder = Color(0xFFD1D5E6);

  static const darkPrimary = Color(0xFF575a6a); // Dark Slate Grey
  static const darkSecondary = Color(0xFF22D3EE); // Neon Cyan
  static const darkSecondaryVariant = Color(0xFF06B6D4);
  static const darkTertiary = Color(0xFFF43F5E); // Neon Rose

  static const darkBackground = Color(0xFF0F172A); // Deep Space Blue
  static const darkBackgroundVariant = Color(0xFF020617);
  static const darkSurface = Color(0xFF1E293B); // Slate Blue surface
  static const darkSurfaceVariant = Color(0xFF334155); // Lighter Slate

  static const darkTextPrimary = Color(0xFFF1F5F9); // Off-white
  static const darkTextSecondary = Color(0xFF94A3B8); // Slate Grey
  static const darkTextTertiary = Color(0xFF64748B);

  static const darkDivider = Color(0xFF1E293B);
  static const darkBorder = Color(0xFF334155);

  // ===========================================================================
  // SHARED STATUS COLORS (Adjusted for vibrancy)
  // ===========================================================================
  static const success = Color(0xFF10B981); // Emerald
  static const warning = Color(0xFFF59E0B); // Amber
  static const error = Color(0xFFEF4444); // Red
  static const info = Color(0xFF3B82F6); // Blue

  // ===========================================================================
  // GRADIENTS (For Buttons or Headers)
  // ===========================================================================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  // ---------------------------------------------------------------------------
  // LIGHT THEME CONFIGURATION
  // ---------------------------------------------------------------------------
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Poppins', // Suggested Font (Ensure you add this to pubspec)

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightSurfaceVariant,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      surfaceTint: AppColors.lightPrimary,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: AppColors.lightBackground,
    dividerColor: AppColors.lightDivider,

    // Component Themes
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBackground),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
    ),

    // Typography
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
    ),

    iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',

    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkSurfaceVariant,
      secondary: AppColors.darkSecondaryVariant,
      surface: AppColors.darkSurface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: AppColors.darkBackground,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      onError: AppColors.darkBackground,
    ),

    scaffoldBackgroundColor: AppColors.darkBackground,
    dividerColor: AppColors.darkDivider,

    // Component Themes
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
    ),

    // Typography
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
    ),

    iconTheme: const IconThemeData(color: AppColors.darkTextSecondary),
  );
}