import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/services/auth_service.dart';
import '../domain/services/database_encryption_service.dart';
import '../domain/services/notification_service.dart';
import '../domain/services/data_deletion_service.dart';
import 'database_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final encryptionServiceProvider = Provider<DatabaseEncryptionService>((ref) {
  return DatabaseEncryptionService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(
    ref.watch(settingsRepositoryProvider),
    ref.watch(periodRepositoryProvider),
  );
});

final dataDeletionServiceProvider = Provider<DataDeletionService>((ref) {
  return DataDeletionService(
    ref.watch(encryptionServiceProvider),
    ref.watch(notificationServiceProvider),
    ref.watch(databaseProvider),
  );
});
