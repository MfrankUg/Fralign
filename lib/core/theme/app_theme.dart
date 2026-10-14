import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';

/// Fralign Theme — Light & Dark ThemeData builders.
class FralignTheme {
  FralignTheme._();

  // ── Light Theme ──
  static ThemeData light() {
    final textTheme = _buildTextTheme(FralignColors.textPrimaryLight);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: FralignColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: FralignColors.coralRed,
        secondary: FralignColors.emeraldGreen,
        tertiary: FralignColors.vibrantAmber,
        surface: FralignColors.surfaceLight,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: FralignColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: FralignColors.textPrimaryLight,
        ),
        iconTheme: const IconThemeData(color: FralignColors.textPrimaryLight),
      ),
      cardTheme: CardThemeData(
        color: FralignColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FralignRadius.lg),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FralignColors.coralRed,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: FralignSpacing.xxl,
            vertical: FralignSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FralignRadius.md),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FralignColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FralignRadius.md),
          borderSide: BorderSide(color: FralignColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FralignRadius.md),
          borderSide: BorderSide(color: FralignColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FralignRadius.md),
          borderSide: const BorderSide(
            color: FralignColors.vibrantAmber,
            width: 2,
          ),
        ),
        hintStyle: GoogleFonts.inter(
          color: FralignColors.textTertiaryLight,
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FralignSpacing.lg,
          vertical: FralignSpacing.lg,
        ),
      ),
      dividerColor: FralignColors.borderLight,
    );
  }

  // ── Dark Theme ──
  static ThemeData dark() {
    final textTheme = _buildTextTheme(FralignColors.textPrimaryDark);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: FralignColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: FralignColors.coralRed,
        secondary: FralignColors.emeraldGreen,
        tertiary: FralignColors.vibrantAmber,
        surface: FralignColors.surfaceDark,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: FralignColors.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: FralignColors.textPrimaryDark,
        ),
        iconTheme: const IconThemeData(color: FralignColors.textPrimaryDark),
      ),
      cardTheme: CardThemeData(
        color: FralignColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FralignRadius.lg),
          side: BorderSide(
            color: FralignColors.borderDark.withValues(alpha: 0.5),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FralignColors.coralRed,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: FralignSpacing.xxl,
            vertical: FralignSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FralignRadius.md),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FralignColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FralignRadius.md),
          borderSide: BorderSide(color: FralignColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FralignRadius.md),
          borderSide: BorderSide(color: FralignColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FralignRadius.md),
          borderSide: const BorderSide(
            color: FralignColors.vibrantAmber,
            width: 2,
          ),
        ),
        hintStyle: GoogleFonts.inter(
          color: FralignColors.textTertiaryDark,
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FralignSpacing.lg,
          vertical: FralignSpacing.lg,
        ),
      ),
      dividerColor: FralignColors.borderDark,
    );
  }

  // ── Text Theme ──
  static TextTheme _buildTextTheme(Color baseColor) {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: baseColor,
        letterSpacing: -0.5,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: baseColor,
        letterSpacing: -0.3,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: baseColor.withValues(alpha: 0.6),
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: 0.1,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: baseColor.withValues(alpha: 0.5),
        letterSpacing: 0.5,
      ),
    );
  }
}
