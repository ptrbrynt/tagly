import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/data/barbershop_tags_api.dart';
import 'package:tagly/db/queries/tag_queries.dart';
import 'package:tagly/db/queries/video_queries.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

class TagsRepository extends ChangeNotifier {
  TagsRepository({required Database db, required BarbershopTagsApi api})
    : _api = api,
      _db = db;

  final Database _db;
  final BarbershopTagsApi _api;

  /// Fetches the latest tags from the API and stores them in the database
  Future<Result<void>> syncTags() async {
    try {
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

      notifyListeners();
      return .ok(null);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    } on DioException catch (e) {
      return .failure(e.message ?? 'Something went wrong.');
    }
  }

  Future<Result<List<BarbershopTag>>> searchTags(String query) async {
    if (query.isEmpty) return .ok([]);
    try {
      final result = await _db.rawQuery(TagQueries.search, [query]);

      return .ok(result.map((row) => BarbershopTag.fromMap(row)).toList());
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }
}
