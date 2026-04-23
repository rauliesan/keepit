import 'package:isar/isar.dart';

part 'weight_entry.g.dart';

@collection
class WeightEntry {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  late double weightKg;

  String? note;

  /// Mood from 1–5 (optional). Null means no mood recorded.
  int? mood;

  /// Timestamp when the entry was created.
  late DateTime createdAt;

  /// Timestamp when the entry was last modified.
  late DateTime updatedAt;

  WeightEntry();

  WeightEntry.create({
    required this.date,
    required this.weightKg,
    this.note,
    this.mood,
  }) {
    final now = DateTime.now();
    createdAt = now;
    updatedAt = now;
    // Normalize date to midnight for consistent daily lookups
    date = DateTime(date.year, date.month, date.day);
  }
}
