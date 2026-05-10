import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/db/schema.dart';

Future<Database> openTaglyDatabase({
  String? path,
  bool singleInstance = true,
}) async {
  final filePath = (path == inMemoryDatabasePath)
      ? inMemoryDatabasePath
      : join(path ?? await getDatabasesPath(), 'tagly.db');
  return openDatabase(
    filePath,
    version: Schema.version,
    onConfigure: Schema.onConfigure,
    onCreate: Schema.onCreate,
    singleInstance: singleInstance,
  );
}
