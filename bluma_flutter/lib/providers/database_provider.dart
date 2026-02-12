import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import '../data/repositories/period_repository.dart';
import '../data/repositories/health_repository.dart';
import '../data/repositories/settings_repository.dart';
import 'service_provider.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final encryptionService = ref.read(encryptionServiceProvider);
  String? key;
  try {
    key = encryptionService.getEncryptionKeyHex();
  } catch (e) {
    // If key not initialized, it will be initialized by the init screen
  }

  final db = AppDatabase(encryptionKey: key);
  ref.onDispose(() => db.close());
  return db;
});

final periodRepositoryProvider = Provider<PeriodRepository>((ref) {
  return PeriodRepository(ref.watch(databaseProvider));
});

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepository(ref.watch(databaseProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(databaseProvider));
});
