import 'package:isar/isar.dart';

part 'streak_data.g.dart';

@collection
class StreakData {
  Id id = 0; // Singleton — always ID 0

  late int currentStreak;
  late int longestStreak;

  /// The last date a weight was logged (midnight-normalized).
  DateTime? lastLogDate;

  /// Number of streak freezes available.
  late int freezesAvailable;

  /// Total number of weight entries ever logged.
  late int totalLogged;

  StreakData();

  StreakData.create({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastLogDate,
    this.freezesAvailable = 0,
    this.totalLogged = 0,
  });
}
