import 'package:isar/isar.dart';
import '../models/weight_entry.dart';
import '../database/isar_service.dart';

/// Repository for WeightEntry CRUD operations.
class WeightRepository {
  Isar get _db => IsarService.instance;

  /// Save or update a weight entry for the given date.
  /// If an entry already exists for this date, it updates it.
  Future<WeightEntry> saveEntry({
    required DateTime date,
    required double weightKg,
    String? note,
    int? mood,
  }) async {
    final normalized = DateTime(date.year, date.month, date.day);

    // Check for existing entry on this date
    final existing = await _db.weightEntrys
        .filter()
        .dateEqualTo(normalized)
        .findFirst();

    if (existing != null) {
      existing.weightKg = weightKg;
      existing.note = note;
      existing.mood = mood;
      existing.updatedAt = DateTime.now();
      await _db.writeTxn(() async {
        await _db.weightEntrys.put(existing);
      });
      return existing;
    }

    final entry = WeightEntry.create(
      date: normalized,
      weightKg: weightKg,
      note: note,
      mood: mood,
    );

    await _db.writeTxn(() async {
      await _db.weightEntrys.put(entry);
    });

    return entry;
  }

  /// Get today's entry, or null.
  Future<WeightEntry?> getToday() async {
    final today = DateTime.now();
    final normalized = DateTime(today.year, today.month, today.day);
    return _db.weightEntrys
        .filter()
        .dateEqualTo(normalized)
        .findFirst();
  }

  /// Get entry for a specific date, or null.
  Future<WeightEntry?> getByDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    return _db.weightEntrys
        .filter()
        .dateEqualTo(normalized)
        .findFirst();
  }

  /// Get all entries sorted by date ascending.
  Future<List<WeightEntry>> getAllEntries() async {
    return _db.weightEntrys
        .where()
        .sortByDate()
        .findAll();
  }

  /// Get entries within a date range.
  Future<List<WeightEntry>> getEntriesInRange(DateTime start, DateTime end) async {
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day, 23, 59, 59);
    return _db.weightEntrys
        .filter()
        .dateBetween(normalizedStart, normalizedEnd)
        .sortByDate()
        .findAll();
  }

  /// Get the most recent N entries.
  Future<List<WeightEntry>> getRecentEntries(int count) async {
    return _db.weightEntrys
        .where()
        .sortByDateDesc()
        .limit(count)
        .findAll();
  }

  /// Get total count of entries.
  Future<int> getCount() async {
    return _db.weightEntrys.count();
  }

  /// Get all dates that have logged entries (for streak display).
  Future<Set<DateTime>> getLoggedDates() async {
    final entries = await getAllEntries();
    return entries.map((e) => DateTime(e.date.year, e.date.month, e.date.day)).toSet();
  }

  /// Delete a specific entry.
  Future<void> deleteEntry(int id) async {
    await _db.writeTxn(() async {
      await _db.weightEntrys.delete(id);
    });
  }

  /// Delete all entries.
  Future<void> deleteAll() async {
    await _db.writeTxn(() async {
      await _db.weightEntrys.clear();
    });
  }

  /// Import entries (merge: skip existing dates, add new).
  Future<int> importEntries(List<WeightEntry> entries) async {
    int imported = 0;
    await _db.writeTxn(() async {
      for (final entry in entries) {
        final existing = await _db.weightEntrys
            .filter()
            .dateEqualTo(entry.date)
            .findFirst();
        if (existing == null) {
          await _db.weightEntrys.put(entry);
          imported++;
        }
      }
    });
    return imported;
  }
}
