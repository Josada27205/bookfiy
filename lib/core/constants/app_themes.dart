import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppThemes {
  AppThemes._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryGreen,
    scaffoldBackgroundColor: AppColors.backgroundLight,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryGreen,
      secondary: AppColors.primaryBlue,
      tertiary: AppColors.primaryTeal,
      surface: AppColors.surface,
      background: AppColors.backgroundLight,
      error: AppColors.error,
      onPrimary: AppColors.textWhite,
      onSecondary: AppColors.textWhite,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
      onError: AppColors.textWhite,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundWhite,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: GoogleFonts.roboto(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryGreen,
        side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        textStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: GoogleFonts.roboto(color: AppColors.textHint, fontSize: 14),
      labelStyle: GoogleFonts.roboto(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
      errorStyle: GoogleFonts.roboto(color: AppColors.error, fontSize: 12),
    ),

    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.surface,
      shadowColor: AppColors.shadowColor,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.textWhite,
      elevation: 4,
      shape: CircleBorder(),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    textTheme: TextTheme(
      // Display
      displayLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),

      // Headline
      headlineLarge: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),

      // Title
      titleLarge: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),

      // Body
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),

      // Label
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    ),
  );
}
