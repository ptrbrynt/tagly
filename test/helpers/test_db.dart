import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tagly/db/database.dart';
import 'package:tagly/db/queries/tag_queries.dart';
import 'package:tagly/db/queries/video_queries.dart';

import 'fake_tags.dart';

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

Future<void> seedTestDb(Database db) async {
  final batch = db.batch();
  for (final tag in fakeTags) {
    batch.rawInsert(TagQueries.upsert, tag.toMap().values.toList());
    for (final video in tag.videos) {
      batch.rawInsert(VideoQueries.upsert, video.toMap().values.toList());
    }
  }

  await batch.commit(noResult: true);
}
