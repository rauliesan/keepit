import 'package:flutter/animation.dart';

/// Animation duration and curve constants for consistent motion design.
class AppAnimations {
  AppAnimations._();

  // ─── Durations ─────────────────────────────────────
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration chart = Duration(milliseconds: 1200);
  static const Duration confetti = Duration(milliseconds: 3000);
  static const Duration numberCounter = Duration(milliseconds: 600);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration shimmer = Duration(milliseconds: 1500);
  static const Duration pulse = Duration(milliseconds: 1500);
  static const Duration staggerDelay = Duration(milliseconds: 80);

  // ─── Curves ────────────────────────────────────────
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve entranceCurve = Curves.easeOutQuart;
  static const Curve exitCurve = Curves.easeInCubic;
  static const Curve springCurve = Curves.easeOutBack;
}
