import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system using three font families:
/// - Nunito: headings (rounded, friendly)
/// - DM Sans: body text
/// - Space Grotesk: numbers & stats (precision feel)
class AppTypography {
  AppTypography._();

  // ─── Heading Styles (Nunito) ───────────────────────
  static TextStyle displayLarge(Color color) => GoogleFonts.nunito(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: color,
        height: 1.1,
      );

  static TextStyle displayMedium(Color color) => GoogleFonts.nunito(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      );

  static TextStyle headlineLarge(Color color) => GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.25,
      );

  static TextStyle headlineMedium(Color color) => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
      );

  static TextStyle headlineSmall(Color color) => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.35,
      );

  static TextStyle titleLarge(Color color) => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  // ─── Body Styles (DM Sans) ────────────────────────
  static TextStyle bodyLarge(Color color) => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodyMedium(Color color) => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodySmall(Color color) => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle labelLarge(Color color) => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  static TextStyle labelMedium(Color color) => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  static TextStyle labelSmall(Color color) => GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
        letterSpacing: 0.5,
      );

  // ─── Number/Stat Styles (Space Grotesk) ────────────
  static TextStyle statHero(Color color) => GoogleFonts.spaceGrotesk(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.0,
      );

  static TextStyle statLarge(Color color) => GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.1,
      );

  static TextStyle statMedium(Color color) => GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.2,
      );

  static TextStyle statSmall(Color color) => GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.3,
      );

  static TextStyle statTiny(Color color) => GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      );
}
