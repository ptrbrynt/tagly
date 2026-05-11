import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/db/schema.dart';

Future<Database> openTaglyDatabase({
  bool inMemory = false,
  bool singleInstance = true,
}) async {
  late final String filePath;

  if (inMemory) {
    filePath = inMemoryDatabasePath;
  } else {
    final databasesPath = await (Platform.isIOS || Platform.isMacOS
        ? getApplicationDocumentsDirectory()
        : getApplicationSupportDirectory());
    try {
      await databasesPath.create(recursive: true);
      // ignore: empty_catches
    } on FileSystemException {}
    filePath = join(databasesPath.path, 'tagly.db');
  }

  return openDatabase(
    filePath,
    version: Schema.version,
    onConfigure: Schema.onConfigure,
    onCreate: Schema.onCreate,
    singleInstance: singleInstance,
  );
}
