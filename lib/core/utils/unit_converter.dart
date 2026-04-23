/// Unit conversion utilities between metric and imperial systems.
class UnitConverter {
  UnitConverter._();

  // ─── Weight ────────────────────────────────────────
  static const double _kgToLbs = 2.20462;

  static double kgToLbs(double kg) => kg * _kgToLbs;
  static double lbsToKg(double lbs) => lbs / _kgToLbs;

  /// Formats weight with the appropriate unit suffix.
  static String formatWeight(double weightKg, bool isMetric, {int decimals = 1}) {
    if (isMetric) {
      return '${weightKg.toStringAsFixed(decimals)} kg';
    } else {
      return '${kgToLbs(weightKg).toStringAsFixed(decimals)} lbs';
    }
  }

  /// Returns just the numeric value in the user's preferred unit.
  static double displayWeight(double weightKg, bool isMetric) {
    return isMetric ? weightKg : kgToLbs(weightKg);
  }

  /// Converts the displayed value back to kg for storage.
  static double toKg(double value, bool isMetric) {
    return isMetric ? value : lbsToKg(value);
  }

  // ─── Height ────────────────────────────────────────
  static const double _cmToInch = 0.393701;
  static const double _inchToCm = 2.54;

  static double cmToInches(double cm) => cm * _cmToInch;
  static double inchesToCm(double inches) => inches * _inchToCm;

  /// Converts cm to feet and inches. Returns (feet, inches).
  static (int, double) cmToFeetInches(double cm) {
    final totalInches = cmToInches(cm);
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return (feet, inches);
  }

  /// Converts feet and inches to cm.
  static double feetInchesToCm(int feet, double inches) {
    return inchesToCm((feet * 12) + inches);
  }

  /// Formats height with the appropriate unit.
  static String formatHeight(double heightCm, bool isMetric) {
    if (isMetric) {
      return '${heightCm.toStringAsFixed(0)} cm';
    } else {
      final (feet, inches) = cmToFeetInches(heightCm);
      return '${feet}\'${inches.toStringAsFixed(0)}"';
    }
  }

  // ─── Delta Formatting ──────────────────────────────
  /// Formats a weight delta with + or - sign.
  static String formatDelta(double deltaKg, bool isMetric, {int decimals = 1}) {
    final value = isMetric ? deltaKg : kgToLbs(deltaKg);
    final sign = value >= 0 ? '+' : '';
    final unit = isMetric ? 'kg' : 'lbs';
    return '$sign${value.toStringAsFixed(decimals)} $unit';
  }
}
