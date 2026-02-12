import 'package:drift/drift.dart';
import '../database/app_database.dart';

class PeriodRepository {
  final AppDatabase _db;

  PeriodRepository(this._db);

  Future<List<PeriodDate>> getAllPeriodDates() {
    return _db.select(_db.periodDates).get();
  }

  Future<int> addPeriodDate(String date) {
    return _db.into(_db.periodDates).insert(
          PeriodDatesCompanion.insert(date: date),
        );
  }

  Future<void> removePeriodDate(String date) {
    return (_db.delete(_db.periodDates)..where((t) => t.date.equals(date))).go();
  }

  Future<void> deleteAllPeriodDates() {
    return _db.delete(_db.periodDates).go();
  }
}
