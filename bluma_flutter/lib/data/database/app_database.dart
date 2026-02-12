import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

part 'app_database.g.dart';

class PeriodDates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get createdAt => text().withDefault(Constant(DateTime.now().toIso8601String()))();
}

class HealthLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get type => text()(); // 'symptom', 'mood', 'flow', 'discharge', 'notes'
  TextColumn get itemId => text()();
  TextColumn get name => text().nullable()(); // Only used for 'notes' type to store actual note text
  TextColumn get createdAt => text().withDefault(Constant(DateTime.now().toIso8601String()))();
}

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  TextColumn get updatedAt => text().withDefault(Constant(DateTime.now().toIso8601String()))();
}

@DriftDatabase(tables: [PeriodDates, HealthLogs, Settings])
class AppDatabase extends _$AppDatabase {
  final String? encryptionKey;

  AppDatabase({this.encryptionKey}) : super(_openConnection(encryptionKey));

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection(String? encryptionKey) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase(file, setup: (db) {
      if (encryptionKey != null) {
        db.execute("PRAGMA key = '$encryptionKey'");
      }
    });
  });
}
