import 'package:sqflite/sqflite.dart';
import 'package:tagly/db/schema.dart';

Future<Database> openTaglyDatabase({String? path}) async {
  return openDatabase(
    path ?? await getDatabasesPath(),
    version: Schema.version,
    onConfigure: Schema.onConfigure,
    onCreate: Schema.onCreate,
  );
}
