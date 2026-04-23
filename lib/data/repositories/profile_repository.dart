import 'package:isar/isar.dart';
import '../models/user_profile.dart';
import '../database/isar_service.dart';

/// Repository for UserProfile operations (singleton pattern).
class ProfileRepository {
  Isar get _db => IsarService.instance;

  /// Get the user profile. Returns null if not created yet.
  Future<UserProfile?> getProfile() async {
    return _db.userProfiles.get(0);
  }

  /// Create or update the user profile.
  Future<UserProfile> saveProfile(UserProfile profile) async {
    profile.id = 0; // Ensure singleton
    await _db.writeTxn(() async {
      await _db.userProfiles.put(profile);
    });
    return profile;
  }

  /// Update just the name.
  Future<void> updateName(String name) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.name = name;
      await saveProfile(profile);
    }
  }

  /// Update height.
  Future<void> updateHeight(double? heightCm) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.heightCm = heightCm;
      await saveProfile(profile);
    }
  }

  /// Update goal weight and date.
  Future<void> updateGoal({double? goalWeightKg, DateTime? goalDate}) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.goalWeightKg = goalWeightKg;
      profile.goalDate = goalDate;
      await saveProfile(profile);
    }
  }

  /// Update unit system.
  Future<void> updateUnitSystem(UnitSystem unitSystem) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.unitSystem = unitSystem;
      await saveProfile(profile);
    }
  }

  /// Update theme preference.
  Future<void> updateTheme(ThemePreference pref) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.themePreference = pref;
      await saveProfile(profile);
    }
  }

  /// Update reminder time.
  Future<void> updateReminderTime(String? time) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.reminderTime = time;
      await saveProfile(profile);
    }
  }

  /// Update first day of week.
  Future<void> updateFirstDayOfWeek(FirstDayOfWeek day) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.firstDayOfWeek = day;
      await saveProfile(profile);
    }
  }

  /// Mark onboarding as completed.
  Future<void> completeOnboarding() async {
    final profile = await getProfile();
    if (profile != null) {
      profile.onboardingCompleted = true;
      await saveProfile(profile);
    }
  }

  /// Check if onboarding is completed.
  Future<bool> isOnboardingCompleted() async {
    final profile = await getProfile();
    return profile?.onboardingCompleted ?? false;
  }

  /// Delete profile (for clear all data).
  Future<void> deleteProfile() async {
    await _db.writeTxn(() async {
      await _db.userProfiles.clear();
    });
  }
}
