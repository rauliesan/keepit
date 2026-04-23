import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/weight_entry.dart';
import '../models/user_profile.dart';
import '../models/streak_data.dart';

/// Singleton service for Isar database initialization and access.
class IsarService {
  static Isar? _instance;

  IsarService._();

  /// Opens the Isar database instance. Call once at app startup.
  static Future<Isar> initialize() async {
    if (_instance != null && _instance!.isOpen) return _instance!;

    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [WeightEntrySchema, UserProfileSchema, StreakDataSchema],
      directory: dir.path,
      name: 'keepit_db',
    );

    return _instance!;
  }

  /// Returns the current Isar instance. Throws if not initialized.
  static Isar get instance {
    if (_instance == null || !_instance!.isOpen) {
      throw StateError('Isar not initialized. Call IsarService.initialize() first.');
    }
    return _instance!;
  }

  /// Closes the database. Used for testing or cleanup.
  static Future<void> close() async {
    if (_instance != null && _instance!.isOpen) {
      await _instance!.close();
      _instance = null;
    }
  }
}
