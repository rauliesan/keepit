import 'package:flutter/material.dart';

/// Centralized color tokens for the KeepIt design system.
/// "Soft Futurism" palette — clean, airy, premium feel.
class AppColors {
  AppColors._();

  // ─── Light Theme ───────────────────────────────────
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF8B8FA8);
  static const Color surfaceLight = Color(0xFFEEF1F7);
  static const Color dividerLight = Color(0xFFE4E7EF);

  // ─── Dark Theme ────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0F0F1A);
  static const Color cardDark = Color(0xFF1A1A2E);
  static const Color textPrimaryDark = Color(0xFFF0F0F5);
  static const Color textSecondaryDark = Color(0xFF8B8FA8);
  static const Color surfaceDark = Color(0xFF252540);
  static const Color dividerDark = Color(0xFF2E2E4A);

  // ─── Accent Colors (shared) ────────────────────────
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42DB);
  static const Color secondary = Color(0xFF43E8C5);
  static const Color secondaryDark = Color(0xFF2BC4A4);

  // ─── Semantic Colors ───────────────────────────────
  static const Color positive = Color(0xFF43E8C5);
  static const Color alert = Color(0xFFFF6B6B);
  static const Color streakFire = Color(0xFFFF9500);
  static const Color streakFireGlow = Color(0xFFFFBE4D);

  // ─── BMI Gradient ──────────────────────────────────
  static const Color bmiUnderweight = Color(0xFF64B5F6);
  static const Color bmiNormal = Color(0xFF43E8C5);
  static const Color bmiOverweight = Color(0xFFFFB74D);
  static const Color bmiObese = Color(0xFFFF6B6B);

  // ─── Chart ─────────────────────────────────────────
  static const Color chartLine = primary;
  static const Color chartGradientTop = Color(0x806C63FF);
  static const Color chartGradientBottom = Color(0x006C63FF);
  static const Color chartMovingAvg = Color(0xFF43E8C5);
  static const Color chartGoalLine = Color(0xFFFF9500);
  static const Color chartTooltipBg = Color(0xFF1A1A2E);

  // ─── Gradients ─────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6C63FF),
      Color(0xFF9D97FF),
    ],
  );

  static const LinearGradient heroGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4A42DB),
      Color(0xFF6C63FF),
    ],
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD700),
      Color(0xFFFFA500),
      Color(0xFFFFD700),
    ],
  );

  // ─── Achievement Badge ─────────────────────────────
  static const Color badgeLocked = Color(0xFFBEC3D0);
  static const Color badgeGold = Color(0xFFFFD700);
  static const Color badgeGoldDark = Color(0xFFDAA520);

  // ─── Mood Colors ───────────────────────────────────
  static const List<Color> moodColors = [
    Color(0xFFFF6B6B),
    Color(0xFFFFB74D),
    Color(0xFFFFE082),
    Color(0xFF81C784),
    Color(0xFF43E8C5),
  ];
}
