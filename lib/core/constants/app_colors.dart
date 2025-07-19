import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors - Green-Blue Theme
  static const Color primaryGreen = Color(0xFF00BFA5);
  static const Color primaryBlue = Color(0xFF00ACC1);
  static const Color primaryTeal = Color(0xFF26A69A);

  // Secondary Colors
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color secondaryBlue = Color(0xFF0288D1);
  static const Color secondaryTeal = Color(0xFF00897B);

  // Accent Colors
  static const Color accentGreen = Color(0xFF69F0AE);
  static const Color accentBlue = Color(0xFF40C4FF);
  static const Color accentTeal = Color(0xFF64FFDA);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5FFFE);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE0F2F1);

  // Error & Success
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF0288D1);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, primaryBlue],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryTeal, primaryBlue],
  );

  // Shadow
  static const Color shadowColor = Color(0x1A000000);

  // Divider
  static const Color divider = Color(0xFFE0E0E0);
}
