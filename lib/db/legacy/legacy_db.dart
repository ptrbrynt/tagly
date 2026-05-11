import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Opens the database from previous versions of the app.
///
/// Intended only for migrations to the new database.
Future<Database> openLegacyDatabase({
  String? path,
  bool singleInstance = true,
}) async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final dbFile = join(dbFolder.path, 'tagly.sqlite');

  return openDatabase(
    path ?? dbFile,
    version: 3,
    singleInstance: singleInstance,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS my_lists (
          id          INTEGER PRIMARY KEY AUTOINCREMENT,
          name        TEXT NOT NULL,
          tags        TEXT NOT NULL
        )
''');
    },
  );
}
