import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import '../../data/models/weight_entry.dart';

/// CSV export and import utilities for weight entries.
class CsvUtils {
  CsvUtils._();

  static const String _header = 'Date,Weight (kg),Note,Mood';
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  /// Converts a list of weight entries to CSV string.
  static String entriesToCsv(List<WeightEntry> entries) {
    final rows = <List<dynamic>>[
      ['Date', 'Weight (kg)', 'Note', 'Mood'],
      ...entries.map((e) => [
            _dateFormat.format(e.date),
            e.weightKg.toStringAsFixed(1),
            e.note ?? '',
            e.mood?.toString() ?? '',
          ]),
    ];
    return const ListToCsvConverter().convert(rows);
  }

  /// Parses CSV string into weight entries.
  /// Returns a list of entries, skipping the header row and invalid rows.
  static List<WeightEntry> csvToEntries(String csvString) {
    final rows = const CsvToListConverter().convert(csvString);
    if (rows.isEmpty) return [];

    final entries = <WeightEntry>[];
    // Skip header row
    for (int i = 1; i < rows.length; i++) {
      try {
        final row = rows[i];
        if (row.length < 2) continue;

        final date = _dateFormat.parse(row[0].toString());
        final weight = double.parse(row[1].toString());
        final note = row.length > 2 && row[2].toString().isNotEmpty
            ? row[2].toString()
            : null;
        final mood = row.length > 3 && row[3].toString().isNotEmpty
            ? int.tryParse(row[3].toString())
            : null;

        entries.add(WeightEntry.create(
          date: date,
          weightKg: weight,
          note: note,
          mood: mood,
        ));
      } catch (_) {
        // Skip invalid rows silently
        continue;
      }
    }

    return entries;
  }
}
