import 'package:flutter/material.dart';

/// Elevation and shadow tokens for the KeepIt design system.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> cardLight = [
    BoxShadow(
      color: const Color(0xFF6C63FF).withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> cardDark = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> cardElevated = [
    BoxShadow(
      color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
      blurRadius: 30,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> fab = [
    BoxShadow(
      color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
      blurRadius: 20,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> bottomNav = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 20,
      offset: const Offset(0, -4),
      spreadRadius: 0,
    ),
  ];
}
