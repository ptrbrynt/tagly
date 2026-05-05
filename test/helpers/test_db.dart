import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tagly/db/database.dart';

bool _ffiInitialized = false;

Future<Database> openTestDb() async {
  if (!_ffiInitialized) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    _ffiInitialized = true;
  }
  final db = await openTaglyDatabase(
    path: inMemoryDatabasePath,
    singleInstance: false,
  );
  return db;
}
