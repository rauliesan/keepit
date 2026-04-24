import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_profile.dart';
import '../data/models/weight_entry.dart';
import '../data/models/streak_data.dart';
import '../data/repositories/weight_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/streak_repository.dart';
import '../core/utils/streak_calculator.dart';
import '../core/constants/app_strings.dart';

// ─── Repositories ────────────────────────────────────
final weightRepositoryProvider = Provider((ref) => WeightRepository());
final profileRepositoryProvider = Provider((ref) => ProfileRepository());
final streakRepositoryProvider = Provider((ref) => StreakRepository());

// ─── Profile ─────────────────────────────────────────
final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  return ProfileNotifier(ref.read(profileRepositoryProvider));
});

class ProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final ProfileRepository _repo;

  ProfileNotifier(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final profile = await _repo.getProfile();
      state = AsyncValue.data(profile);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _repo.saveProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> updateName(String name) async {
    await _repo.updateName(name);
    await _load();
  }

  Future<void> updateHeight(double? heightCm) async {
    await _repo.updateHeight(heightCm);
    await _load();
  }

  Future<void> updateGoal({double? goalWeightKg, DateTime? goalDate}) async {
    await _repo.updateGoal(goalWeightKg: goalWeightKg, goalDate: goalDate);
    await _load();
  }

  Future<void> updateUnitSystem(UnitSystem unitSystem) async {
    await _repo.updateUnitSystem(unitSystem);
    await _load();
  }

  Future<void> updateTheme(ThemePreference pref) async {
    await _repo.updateTheme(pref);
    await _load();
  }

  Future<void> updateReminderTime(String? time) async {
    await _repo.updateReminderTime(time);
    await _load();
  }

  Future<void> updateFirstDayOfWeek(FirstDayOfWeek day) async {
    await _repo.updateFirstDayOfWeek(day);
    await _load();
  }

  Future<void> updateLanguage(AppLanguage language) async {
    await _repo.updateLanguage(language);
    await _load();
  }

  Future<void> completeOnboarding() async {
    await _repo.completeOnboarding();
    await _load();
  }

  Future<void> deleteProfile() async {
    await _repo.deleteProfile();
    state = const AsyncValue.data(null);
  }

  Future<void> refresh() async => _load();
}

// ─── Weight Entries ──────────────────────────────────
final weightEntriesProvider = StateNotifierProvider<WeightEntriesNotifier, AsyncValue<List<WeightEntry>>>((ref) {
  return WeightEntriesNotifier(ref.read(weightRepositoryProvider));
});

class WeightEntriesNotifier extends StateNotifier<AsyncValue<List<WeightEntry>>> {
  final WeightRepository _repo;

  WeightEntriesNotifier(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final entries = await _repo.getAllEntries();
      state = AsyncValue.data(entries);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<WeightEntry> saveEntry({
    required DateTime date,
    required double weightKg,
    String? note,
    int? mood,
  }) async {
    final entry = await _repo.saveEntry(
      date: date,
      weightKg: weightKg,
      note: note,
      mood: mood,
    );
    await _load();
    return entry;
  }

  Future<void> deleteEntry(int id) async {
    await _repo.deleteEntry(id);
    await _load();
  }

  Future<void> deleteAll() async {
    await _repo.deleteAll();
    state = const AsyncValue.data([]);
  }

  Future<int> importEntries(List<WeightEntry> entries) async {
    final count = await _repo.importEntries(entries);
    await _load();
    return count;
  }

  Future<void> refresh() async => _load();
}

// ─── Today's Entry ───────────────────────────────────
final todayEntryProvider = Provider<WeightEntry?>((ref) {
  final entries = ref.watch(weightEntriesProvider);
  return entries.whenOrNull(data: (list) {
    final today = DateTime.now();
    final matches = list.where(
      (e) => e.date.year == today.year &&
             e.date.month == today.month &&
             e.date.day == today.day,
    );
    return matches.isEmpty ? null : matches.first;
  });
});

// ─── Yesterday's Entry ──────────────────────────────
final yesterdayEntryProvider = Provider<WeightEntry?>((ref) {
  final entries = ref.watch(weightEntriesProvider);
  return entries.whenOrNull(data: (list) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final matches = list.where(
      (e) => e.date.year == yesterday.year &&
             e.date.month == yesterday.month &&
             e.date.day == yesterday.day,
    );
    return matches.isEmpty ? null : matches.first;
  });
});

// ─── Streak ──────────────────────────────────────────
final streakProvider = StateNotifierProvider<StreakNotifier, AsyncValue<StreakData>>((ref) {
  return StreakNotifier(ref.read(streakRepositoryProvider));
});

class StreakNotifier extends StateNotifier<AsyncValue<StreakData>> {
  final StreakRepository _repo;

  StreakNotifier(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      var streak = await _repo.getStreak();
      // Check streak validity on load
      streak = StreakCalculator.checkStreakOnLaunch(streak);
      await _repo.saveStreak(streak);
      state = AsyncValue.data(streak);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<StreakUpdateResult> recordLog(DateTime date) async {
    final current = await _repo.getStreak();
    final result = StreakCalculator.updateStreak(current, date);
    await _repo.saveStreak(result.streak);
    state = AsyncValue.data(result.streak);
    return result;
  }

  Future<void> deleteStreak() async {
    await _repo.deleteStreak();
    state = AsyncValue.data(StreakData.create());
  }

  Future<void> refresh() async => _load();
}

// ─── Logged Dates (for streak indicators) ────────────
final loggedDatesProvider = Provider<Set<DateTime>>((ref) {
  final entries = ref.watch(weightEntriesProvider);
  return entries.whenOrNull(data: (list) {
    return list.map((e) => DateTime(e.date.year, e.date.month, e.date.day)).toSet();
  }) ?? {};
});

// ─── Theme ───────────────────────────────────────────
final themeModeProvider = Provider<ThemeMode>((ref) {
  final profile = ref.watch(profileProvider);
  return profile.whenOrNull(data: (p) {
    if (p == null) return ThemeMode.system;
    switch (p.themePreference) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.system:
        return ThemeMode.system;
    }
  }) ?? ThemeMode.system;
});

// ─── Unit System ─────────────────────────────────────
final isMetricProvider = Provider<bool>((ref) {
  final profile = ref.watch(profileProvider);
  return profile.whenOrNull(data: (p) {
    return p?.unitSystem != UnitSystem.imperial;
  }) ?? true;
});

// ─── Achievements ────────────────────────────────────
final achievementsProvider = Provider<List<AchievementStatus>>((ref) {
  final entries = ref.watch(weightEntriesProvider);
  final streak = ref.watch(streakProvider);
  final profile = ref.watch(profileProvider);

  final entryList = entries.whenOrNull(data: (d) => d) ?? [];
  final streakData = streak.whenOrNull(data: (d) => d) ?? StreakData.create();
  final profileData = profile.whenOrNull(data: (d) => d);

  // Ensure AppStrings knows about the current language before calculating names/descriptions
  if (profileData != null) {
    AppStrings.currentLanguage = profileData.language;
  }

  return _calculateAchievements(entryList, streakData, profileData);
});

List<AchievementStatus> _calculateAchievements(
  List<WeightEntry> entries,
  StreakData streak,
  UserProfile? profile,
) {
  final achievements = <AchievementStatus>[];

  // First Step — log your first weight
  achievements.add(AchievementStatus(
    id: 'first_step',
    name: AppStrings.achFirstStepName,
    description: AppStrings.achFirstStepDesc,
    icon: '👣',
    isUnlocked: entries.isNotEmpty,
  ));

  // Week Warrior — 7-day streak
  achievements.add(AchievementStatus(
    id: 'week_warrior',
    name: AppStrings.achWeekWarriorName,
    description: AppStrings.achWeekWarriorDesc,
    icon: '⚔️',
    isUnlocked: streak.longestStreak >= 7,
  ));

  // Month Master — 30-day streak
  achievements.add(AchievementStatus(
    id: 'month_master',
    name: AppStrings.achMonthMasterName,
    description: AppStrings.achMonthMasterDesc,
    icon: '👑',
    isUnlocked: streak.longestStreak >= 30,
  ));

  // First Kilo — lose first kg toward goal
  final goalWeight = profile?.goalWeightKg;
  if (entries.length >= 2 && goalWeight != null) {
    final first = entries.first.weightKg;
    final current = entries.last.weightKg;
    final lostTowardGoal = first > goalWeight
        ? first - current
        : current - first;
    achievements.add(AchievementStatus(
      id: 'first_kilo',
      name: AppStrings.achFirstKiloName,
      description: AppStrings.achFirstKiloDesc,
      icon: '🎯',
      isUnlocked: lostTowardGoal >= 1.0,
    ));
  } else {
    achievements.add(AchievementStatus(
      id: 'first_kilo',
      name: AppStrings.achFirstKiloName,
      description: AppStrings.achFirstKiloDesc,
      icon: '🎯',
      isUnlocked: false,
    ));
  }

  // Halfway There — 50% of goal
  if (entries.length >= 2 && goalWeight != null) {
    final first = entries.first.weightKg;
    final current = entries.last.weightKg;
    final totalToLose = (first - goalWeight).abs();
    final lost = (first - current).abs();
    achievements.add(AchievementStatus(
      id: 'halfway',
      name: AppStrings.achHalfwayName,
      description: AppStrings.achHalfwayDesc,
      icon: '🌟',
      isUnlocked: totalToLose > 0 && lost >= totalToLose * 0.5,
    ));
  } else {
    achievements.add(AchievementStatus(
      id: 'halfway',
      name: AppStrings.achHalfwayName,
      description: AppStrings.achHalfwayDesc,
      icon: '🌟',
      isUnlocked: false,
    ));
  }

  // Goal Crusher — goal weight reached
  if (entries.isNotEmpty && goalWeight != null) {
    final current = entries.last.weightKg;
    final first = entries.first.weightKg;
    final isReached = first > goalWeight
        ? current <= goalWeight
        : current >= goalWeight;
    achievements.add(AchievementStatus(
      id: 'goal_crusher',
      name: AppStrings.achGoalCrusherName,
      description: AppStrings.achGoalCrusherDesc,
      icon: '🏆',
      isUnlocked: isReached,
    ));
  } else {
    achievements.add(AchievementStatus(
      id: 'goal_crusher',
      name: AppStrings.achGoalCrusherName,
      description: AppStrings.achGoalCrusherDesc,
      icon: '🏆',
      isUnlocked: false,
    ));
  }

  // Data Nerd — 100 entries
  achievements.add(AchievementStatus(
    id: 'data_nerd',
    name: AppStrings.achDataNerdName,
    description: AppStrings.achDataNerdDesc,
    icon: '📊',
    isUnlocked: streak.totalLogged >= 100,
  ));

  // Comeback Kid — restart a broken streak
  achievements.add(AchievementStatus(
    id: 'comeback_kid',
    name: AppStrings.achComebackName,
    description: AppStrings.achComebackDesc,
    icon: '💪',
    isUnlocked: streak.currentStreak >= 1 && streak.longestStreak > streak.currentStreak,
  ));

  return achievements;
}

class AchievementStatus {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isUnlocked;

  const AchievementStatus({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });
}
