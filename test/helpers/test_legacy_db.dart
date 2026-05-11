import 'package:sqflite_common_ffi/sqflite_ffi.dart';

bool _ffiInitialized = false;

Future<Database> openTestLegacyDb() async {
  if (!_ffiInitialized) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    _ffiInitialized = true;
  }
  final db = await openDatabase(
    inMemoryDatabasePath,
    version: 3,
    singleInstance: false,
  );
  await db.execute('''
    CREATE TABLE my_lists (
      id    INTEGER PRIMARY KEY AUTOINCREMENT,
      name  TEXT NOT NULL,
      tags  TEXT NOT NULL
    )
  ''');
  return db;
}
