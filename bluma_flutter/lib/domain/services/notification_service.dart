import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'period_prediction_service.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/period_repository.dart';

class NotificationService {
  static const String _beforePeriodKey = 'notifications_period_before';
  static const String _dayOfPeriodKey = 'notifications_period_day';
  static const String _latePeriodKey = 'notifications_period_late';
  static const String _timeHourKey = 'notification_time_hour';
  static const String _timeMinuteKey = 'notification_time_minute';

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final SettingsRepository _settingsRepository;
  final PeriodRepository _periodRepository;

  NotificationService(this._settingsRepository, this._periodRepository);

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(_beforePeriodKey) ?? false) ||
        (prefs.getBool(_dayOfPeriodKey) ?? false) ||
        (prefs.getBool(_latePeriodKey) ?? false);
  }

  Future<Map<String, bool>> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'beforePeriodEnabled': prefs.getBool(_beforePeriodKey) ?? false,
      'dayOfPeriodEnabled': prefs.getBool(_dayOfPeriodKey) ?? false,
      'latePeriodEnabled': prefs.getBool(_latePeriodKey) ?? false,
    };
  }

  Future<void> saveNotificationSettings(
    bool beforePeriodEnabled,
    bool dayOfPeriodEnabled,
    bool latePeriodEnabled,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_beforePeriodKey, beforePeriodEnabled);
    await prefs.setBool(_dayOfPeriodKey, dayOfPeriodEnabled);
    await prefs.setBool(_latePeriodKey, latePeriodEnabled);

    if (beforePeriodEnabled || dayOfPeriodEnabled || latePeriodEnabled) {
      await scheduleNotificationsIfDataExists();
    } else {
      await cancelPeriodNotifications();
    }
  }

  Future<void> scheduleNotificationsIfDataExists() async {
    final periodDates = await _periodRepository.getAllPeriodDates();
    if (periodDates.isNotEmpty) {
      final sortedDates = periodDates.map((e) => e.date).toList();
      final periods = PeriodPredictionService.groupDateIntoPeriods(sortedDates);
      if (periods.isNotEmpty) {
        final mostRecentPeriod = periods[0];
        final mostRecentStart = mostRecentPeriod.last;
        await schedulePeriodReminder(mostRecentStart, sortedDates);
      }
    }
  }

  Future<void> schedulePeriodReminder(
    String startDate,
    List<String> allDates, {
    int daysBefore = 3,
  }) async {
    final settings = await getNotificationSettings();
    if (!settings['beforePeriodEnabled']! &&
        !settings['dayOfPeriodEnabled']! &&
        !settings['latePeriodEnabled']!) {
      return;
    }

    await cancelPeriodNotifications();

    final userCycleLengthStr = await _settingsRepository.getSetting('userCycleLength');
    final userCycleLength = userCycleLengthStr != null ? int.tryParse(userCycleLengthStr) : 28;

    final prefs = await SharedPreferences.getInstance();
    final hour = int.tryParse(prefs.getString(_timeHourKey) ?? '10') ?? 10;
    final minute = int.tryParse(prefs.getString(_timeMinuteKey) ?? '0') ?? 0;

    final prediction = PeriodPredictionService.getPrediction(
      startDate,
      allDates,
      userCycleLength,
    );

    final predictionDate = DateTime.parse(prediction.date);
    final notificationBaseTime = DateTime(
      predictionDate.year,
      predictionDate.month,
      predictionDate.day,
      hour,
      minute,
    );

    const androidDetails = AndroidNotificationDetails(
      'period-notifications',
      'Period Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    if (settings['beforePeriodEnabled']!) {
      final scheduledDate = notificationBaseTime.subtract(Duration(days: daysBefore));
      if (scheduledDate.isAfter(DateTime.now())) {
        await _notificationsPlugin.zonedSchedule(
          1,
          'Period reminder',
          'Your period is expected to start soon.',
          tz.TZDateTime.from(scheduledDate, tz.local),
          notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }

    if (settings['dayOfPeriodEnabled']!) {
      final scheduledDate = notificationBaseTime;
      if (scheduledDate.isAfter(DateTime.now())) {
        await _notificationsPlugin.zonedSchedule(
          2,
          'Period starting',
          'Your period is expected to start today.',
          tz.TZDateTime.from(scheduledDate, tz.local),
          notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }

    if (settings['latePeriodEnabled']!) {
      final scheduledDate = notificationBaseTime.add(const Duration(days: 1));
      if (scheduledDate.isAfter(DateTime.now())) {
        await _notificationsPlugin.zonedSchedule(
          3,
          'Period late',
          'Your period is late.',
          tz.TZDateTime.from(scheduledDate, tz.local),
          notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  Future<void> cancelPeriodNotifications() async {
    await _notificationsPlugin.cancel(1);
    await _notificationsPlugin.cancel(2);
    await _notificationsPlugin.cancel(3);
  }
}
