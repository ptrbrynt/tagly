import 'package:sqflite/sqflite.dart';

class LegacyMigrationRepository {
  LegacyMigrationRepository({
    required Database legacyDatabase,
    required Database newDatabase,
  }) : _legacyDatabase = legacyDatabase,
       _newDatabase = newDatabase;

  final Database _legacyDatabase;
  final Database _newDatabase;

  /// Takes data stored in the `my_lists` table of the legacy database
  /// and saves it in the new database.
  Future<void> migrate() async {
    final myListsData = await _legacyDatabase.query('my_lists');
    // TODO: Save lists
  }
}
