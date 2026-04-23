import 'package:isar/isar.dart';
import '../models/streak_data.dart';
import '../database/isar_service.dart';

/// Repository for streak data operations (singleton pattern).
class StreakRepository {
  Isar get _db => IsarService.instance;

  /// Get the current streak data. Returns a default if not exists.
  Future<StreakData> getStreak() async {
    final data = await _db.streakDatas.get(0);
    return data ?? StreakData.create();
  }

  /// Save streak data.
  Future<StreakData> saveStreak(StreakData streak) async {
    streak.id = 0; // Ensure singleton
    await _db.writeTxn(() async {
      await _db.streakDatas.put(streak);
    });
    return streak;
  }

  /// Clear streak data (for clear all data).
  Future<void> deleteStreak() async {
    await _db.writeTxn(() async {
      await _db.streakDatas.clear();
    });
  }
}
