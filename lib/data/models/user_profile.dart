import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = 0; // Singleton — always ID 0

  late String name;

  /// Height in centimeters. Null means BMI should be hidden.
  double? heightCm;

  /// Optional goal weight in kilograms.
  double? goalWeightKg;

  /// Optional target date for reaching goal weight.
  DateTime? goalDate;

  /// 'metric' or 'imperial'
  @Enumerated(EnumType.name)
  late UnitSystem unitSystem;

  /// Optional age.
  int? age;

  /// Optional biological sex: 'male', 'female', or null.
  String? biologicalSex;

  /// Optional daily reminder time stored as "HH:mm".
  String? reminderTime;

  /// Theme mode: 'light', 'dark', or 'system'.
  @Enumerated(EnumType.name)
  late ThemePreference themePreference;

  /// First day of week: 'monday' or 'sunday'.
  @Enumerated(EnumType.name)
  late FirstDayOfWeek firstDayOfWeek;

  /// Whether onboarding has been completed.
  late bool onboardingCompleted;

  UserProfile();

  UserProfile.create({
    required this.name,
    this.heightCm,
    this.goalWeightKg,
    this.goalDate,
    this.unitSystem = UnitSystem.metric,
    this.age,
    this.biologicalSex,
    this.reminderTime,
    this.themePreference = ThemePreference.system,
    this.firstDayOfWeek = FirstDayOfWeek.monday,
    this.onboardingCompleted = false,
  });
}

enum UnitSystem {
  metric,
  imperial,
}

enum ThemePreference {
  light,
  dark,
  system,
}

enum FirstDayOfWeek {
  monday,
  sunday,
}
