import 'package:intl/intl.dart';

/// Date-related utility functions.
class AppDateUtils {
  AppDateUtils._();

  /// Returns time-aware greeting based on current hour.
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// Formats date as "Mon, Apr 21" style.
  static String formatShort(DateTime date) {
    return DateFormat('EEE, MMM d').format(date);
  }

  /// Formats date as "April 21, 2026".
  static String formatLong(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  /// Formats date as "Apr 21".
  static String formatCompact(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  /// Formats date as "21/04/2026".
  static String formatNumeric(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Returns the day name abbreviation (Mo, Tu, We, etc.)
  static String dayInitial(DateTime date) {
    return DateFormat('E').format(date).substring(0, 2);
  }

  /// Normalizes a DateTime to midnight.
  static DateTime normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns today's date normalized to midnight.
  static DateTime get today => normalize(DateTime.now());

  /// Returns yesterday's date.
  static DateTime get yesterday => today.subtract(const Duration(days: 1));

  /// Whether two dates are the same calendar day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Returns the start of the current week.
  static DateTime startOfWeek(DateTime date, {bool mondayFirst = true}) {
    final normalized = normalize(date);
    int diff = normalized.weekday - (mondayFirst ? DateTime.monday : DateTime.sunday);
    if (diff < 0) diff += 7;
    return normalized.subtract(Duration(days: diff));
  }

  /// Returns the start of the current month.
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Returns date range label for chart.
  static String dateRangeLabel(DateTime start, DateTime end) {
    if (start.year == end.year) {
      return '${formatCompact(start)} — ${formatCompact(end)}';
    }
    return '${formatCompact(start)}, ${start.year} — ${formatCompact(end)}, ${end.year}';
  }
}
