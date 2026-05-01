import 'package:sqflite/sqflite.dart';
import 'package:tagly/data/barbershop_tags_api.dart';
import 'package:tagly/db/queries/tag_queries.dart';
import 'package:tagly/db/queries/video_queries.dart';

class TagsSyncRepository {
  TagsSyncRepository({required Database db, required BarbershopTagsApi api})
    : _api = api,
      _db = db;

  final Database _db;
  final BarbershopTagsApi _api;

  Future<void> syncTags() async {
    // Calls the API to check how many tags are available.
    final tagsCountResponse = await _api.getTags(count: 1);

    final allTagsResponse = await _api.getTags(
      count: tagsCountResponse.available,
    );

    final batch = _db.batch();
    for (final tag in allTagsResponse.tags) {
      batch.rawInsert(TagQueries.upsert, tag.toMap().values.toList());
      for (final video in tag.videos) {
        batch.rawInsert(VideoQueries.upsert, video.toMap().values.toList());
      }
    }
    await batch.commit(noResult: true);
  }
}
