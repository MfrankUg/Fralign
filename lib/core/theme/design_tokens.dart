import 'package:flutter/material.dart';

/// Fralign Design System — Design Tokens
/// Derived from the 2020 original theme, modernized for 2024+.
class FralignColors {
  FralignColors._();

  // ── Primary Accents ──
  static const Color coralRed = Color(0xFFFF3B30);
  static const Color coralRedDark = Color(0xFFE53935);
  static const Color coralRedLight = Color(0xFFFF6B6B);

  // ── Secondary Accents ──
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color emeraldGreenDark = Color(0xFF059669);

  // ── Accent / Focus ──
  static const Color vibrantAmber = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFBBF24);

  // ── Light Mode Neutrals ──
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textTertiaryLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);

  // ── Dark Mode Neutrals ──
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceDarkElevated = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);
  static const Color borderDark = Color(0xFF334155);
}

class FralignSpacing {
  FralignSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;
}

class FralignRadius {
  FralignRadius._();

  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double pill = 100.0;
}

class FralignShadows {
  FralignShadows._();

  static List<BoxShadow> cardLight = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> cardDark = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> elevatedLight = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> glowRed = [
    BoxShadow(
      color: FralignColors.coralRed.withValues(alpha: 0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
}

class FralignDurations {
  FralignDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration ripple = Duration(milliseconds: 1500);
}
