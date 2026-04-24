import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;

/// Singleton service for scheduling and managing local notifications.
class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const int _dailyReminderId = 0;
  static const String _channelId = 'keepit_daily_reminder';
  static const String _channelName = 'Daily Reminder';
  static const String _channelDesc = 'Daily weight logging reminder';

  /// Initialize the notification plugin. Call once at app startup.
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone database
    tz_data.initializeTimeZones();
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_keepit',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
    debugPrint('[NotificationService] Initialized');
  }

  /// Request notification permissions (Android 13+ / iOS).
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      debugPrint('[NotificationService] Notification permission: $status');
      if (!status.isGranted) return false;

      // On Android 12+, exact alarms need separate permission
      final exactAlarm = await Permission.scheduleExactAlarm.request();
      debugPrint('[NotificationService] Exact alarm permission: $exactAlarm');

      return true;
    }
    // iOS permissions are handled via DarwinInitializationSettings
    return true;
  }

  /// Fire an immediate test notification to verify the system works.
  Future<void> showTestNotification() async {
    if (!_initialized) return;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      99,
      'KeepIt Reminder 📊',
      'Your daily reminder has been set! We\'ll remind you to log your weight 🔥',
      details,
    );
    debugPrint('[NotificationService] Test notification fired');
  }

  /// Schedule a daily repeating notification at the given time.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) {
      debugPrint('[NotificationService] Not initialized, skipping schedule');
      return;
    }

    // Cancel any existing reminder first
    await cancelDailyReminder();

    // Request permissions
    final granted = await requestPermissions();
    if (!granted) {
      debugPrint('[NotificationService] Permission denied');
      return;
    }

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_keepit',
      category: AndroidNotificationCategory.reminder,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    debugPrint('[NotificationService] Now: $now, scheduling for: $scheduledDate');

    try {
      await _plugin.zonedSchedule(
        _dailyReminderId,
        'KeepIt Reminder 📊',
        'Time to log your weight! Keep your streak going 🔥',
        scheduledDate,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint(
          '[NotificationService] ✅ Scheduled at $hour:${minute.toString().padLeft(2, '0')} (next: $scheduledDate)');
    } catch (e) {
      debugPrint('[NotificationService] ❌ Failed to schedule: $e');
    }
  }

  /// Cancel the daily reminder notification.
  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(_dailyReminderId);
    debugPrint('[NotificationService] Daily reminder cancelled');
  }

  /// Cancel today's reminder (user already logged) and reschedule for tomorrow.
  ///
  /// This is called when the user logs their weight — we cancel any pending
  /// notification for today and schedule the next one for tomorrow at the
  /// same time, so the reminder only fires on days without a log.
  Future<void> cancelTodayAndRescheduleForTomorrow({
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) return;

    // Cancel existing
    await _plugin.cancel(_dailyReminderId);

    // Schedule for tomorrow at the same time
    final now = tz.TZDateTime.now(tz.local);
    final tomorrow = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    ).add(const Duration(days: 1));

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_keepit',
      category: AndroidNotificationCategory.reminder,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      _dailyReminderId,
      'KeepIt Reminder 📊',
      'Time to log your weight! Keep your streak going 🔥',
      tomorrow,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint(
        '[NotificationService] Rescheduled reminder for tomorrow at $hour:${minute.toString().padLeft(2, '0')} (next fire: $tomorrow)');
  }

  /// Handle notification tap — opens the app.
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('[NotificationService] Notification tapped: ${response.payload}');
  }

}
