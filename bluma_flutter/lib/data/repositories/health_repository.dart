import 'package:drift/drift.dart';
import '../database/app_database.dart';

class HealthRepository {
  final AppDatabase _db;

  HealthRepository(this._db);

  Future<List<HealthLog>> getAllHealthLogs() {
    return _db.select(_db.healthLogs).get();
  }

  Future<List<HealthLog>> getHealthLogsByDate(String date) {
    return (_db.select(_db.healthLogs)..where((t) => t.date.equals(date))).get();
  }

  Future<int> addHealthLog({
    required String date,
    required String type,
    required String itemId,
    String? name,
  }) {
    return _db.into(_db.healthLogs).insert(
          HealthLogsCompanion.insert(
            date: date,
            type: type,
            itemId: itemId,
            name: Value(name),
          ),
        );
  }

  Future<void> removeHealthLog({
    required String date,
    required String type,
    required String itemId,
  }) {
    return (_db.delete(_db.healthLogs)
          ..where((t) =>
              t.date.equals(date) &
              t.type.equals(type) &
              t.itemId.equals(itemId)))
        .go();
  }

  Future<void> updateNote({
    required String date,
    required String text,
  }) async {
    // Delete existing note for this date
    await (_db.delete(_db.healthLogs)
          ..where((t) => t.date.equals(date) & t.type.equals('notes')))
        .go();

    if (text.isNotEmpty) {
      await addHealthLog(
        date: date,
        type: 'notes',
        itemId: 'notes',
        name: text,
      );
    }
  }

  Future<void> deleteAllHealthLogs() {
    return _db.delete(_db.healthLogs).go();
  }
}
