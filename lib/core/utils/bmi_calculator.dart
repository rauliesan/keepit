/// Calculates BMI and returns category info.
class BmiCalculator {
  BmiCalculator._();

  /// Calculate BMI from weight in kg and height in cm.
  /// Returns null if height is null or zero.
  static double? calculate(double weightKg, double? heightCm) {
    if (heightCm == null || heightCm <= 0) return null;
    final heightM = heightCm / 100.0;
    return weightKg / (heightM * heightM);
  }

  /// Get BMI category label.
  static BmiCategory? getCategory(double? bmi) {
    if (bmi == null) return null;
    if (bmi < 18.5) return BmiCategory.underweight;
    if (bmi < 25.0) return BmiCategory.normal;
    if (bmi < 30.0) return BmiCategory.overweight;
    return BmiCategory.obese;
  }

  /// Get the normalized position (0.0 to 1.0) on the BMI gradient bar.
  /// Maps BMI range 15–40 to 0.0–1.0 for visual indicator.
  static double getBarPosition(double bmi) {
    const minBmi = 15.0;
    const maxBmi = 40.0;
    return ((bmi - minBmi) / (maxBmi - minBmi)).clamp(0.0, 1.0);
  }
}

enum BmiCategory {
  underweight('Underweight'),
  normal('Normal'),
  overweight('Overweight'),
  obese('Obese');

  final String label;
  const BmiCategory(this.label);
}
