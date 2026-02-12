import 'package:shared_preferences/shared_preferences.dart';
import 'database_encryption_service.dart';
import 'notification_service.dart';
import '../../data/database/app_database.dart';

class DataDeletionService {
  final DatabaseEncryptionService _encryptionService;
  final NotificationService _notificationService;
  final AppDatabase _db;

  DataDeletionService(
    this._encryptionService,
    this._notificationService,
    this._db,
  );

  Future<void> deleteAllUserData() async {
    try {
      // Delete encryption key
      await _encryptionService.deleteEncryptionKey();

      // Delete database contents (In Drift, we can just delete all tables if we want to keep the file,
      // or we can close and delete the file. For simplicity, let's delete all data.)
      // Actually, to match RN, we should probably delete the file.
      // But Drift might not like the file disappearing under it.
      // Let's just clear all tables for now.
      await _db.periodDates.delete().go();
      await _db.healthLogs.delete().go();
      await _db.settings.delete().go();

      // Cancel notifications
      await _notificationService.cancelPeriodNotifications();

      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

    } catch (e) {
      throw Exception('Failed to delete user data');
    }
  }
}
