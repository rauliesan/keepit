import '../../../data/models/streak_data.dart';

/// Business logic for streak calculations.
class StreakCalculator {
  StreakCalculator._();

  /// Updates streak data after a new weight log.
  /// Returns the updated StreakData and whether a new record was set.
  static StreakUpdateResult updateStreak(StreakData current, DateTime logDate) {
    final normalizedLogDate = _normalize(logDate);
    final lastLog = current.lastLogDate != null
        ? _normalize(current.lastLogDate!)
        : null;

    bool newRecord = false;
    int newStreak = current.currentStreak;
    int newLongest = current.longestStreak;
    int newFreezes = current.freezesAvailable;
    int newTotal = current.totalLogged;

    // If same day, don't increment streak but update lastLogDate
    if (lastLog != null && normalizedLogDate.isAtSameMomentAs(lastLog)) {
      // Same day — no streak change, but we still count total if it's new
      return StreakUpdateResult(
        streak: current..lastLogDate = normalizedLogDate,
        isNewRecord: false,
        streakBroken: false,
      );
    }

    // Increment total logged
    newTotal += 1;

    if (lastLog == null) {
      // First ever log
      newStreak = 1;
    } else {
      final daysDiff = normalizedLogDate.difference(lastLog).inDays;

      if (daysDiff == 1) {
        // Consecutive day — increment streak
        newStreak += 1;
      } else if (daysDiff == 2 && newFreezes > 0) {
        // Missed exactly 1 day but have a freeze
        newFreezes -= 1;
        newStreak += 1;
      } else {
        // Streak broken — restart
        newStreak = 1;
      }
    }

    // Check for new freeze: earned 1 per completed 7-day streak
    // Award freeze when streak hits a multiple of 7
    if (newStreak > 0 && newStreak % 7 == 0) {
      newFreezes += 1;
    }

    // Check for new record
    if (newStreak > newLongest) {
      newLongest = newStreak;
      newRecord = true;
    }

    final updatedStreak = StreakData.create(
      currentStreak: newStreak,
      longestStreak: newLongest,
      lastLogDate: normalizedLogDate,
      freezesAvailable: newFreezes,
      totalLogged: newTotal,
    );

    return StreakUpdateResult(
      streak: updatedStreak,
      isNewRecord: newRecord,
      streakBroken: lastLog != null &&
          normalizedLogDate.difference(lastLog).inDays > 2,
    );
  }

  /// Checks if the streak is still valid on app launch.
  /// Returns updated data if streak should be broken.
  static StreakData checkStreakOnLaunch(StreakData current) {
    if (current.lastLogDate == null || current.currentStreak == 0) {
      return current;
    }

    final today = _normalize(DateTime.now());
    final lastLog = _normalize(current.lastLogDate!);
    final daysDiff = today.difference(lastLog).inDays;

    if (daysDiff <= 1) {
      // Still valid (logged today or yesterday)
      return current;
    }

    if (daysDiff == 2 && current.freezesAvailable > 0) {
      // Can be saved by freeze — don't break yet, user might log today
      return current;
    }

    // Streak is broken
    return StreakData.create(
      currentStreak: 0,
      longestStreak: current.longestStreak,
      lastLogDate: current.lastLogDate,
      freezesAvailable: current.freezesAvailable,
      totalLogged: current.totalLogged,
    );
  }

  /// Gets the last 7 days' log status for the streak indicator.
  static List<DayStatus> getLast7Days(
    DateTime today,
    Set<DateTime> loggedDates,
  ) {
    final normalizedToday = _normalize(today);
    final result = <DayStatus>[];

    for (int i = 6; i >= 0; i--) {
      final date = normalizedToday.subtract(Duration(days: i));
      final isToday = i == 0;
      final isLogged = loggedDates.contains(date);

      result.add(DayStatus(
        date: date,
        isLogged: isLogged,
        isToday: isToday,
      ));
    }

    return result;
  }

  static DateTime _normalize(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);
}

class StreakUpdateResult {
  final StreakData streak;
  final bool isNewRecord;
  final bool streakBroken;

  const StreakUpdateResult({
    required this.streak,
    required this.isNewRecord,
    required this.streakBroken,
  });
}

class DayStatus {
  final DateTime date;
  final bool isLogged;
  final bool isToday;

  const DayStatus({
    required this.date,
    required this.isLogged,
    required this.isToday,
  });
}
