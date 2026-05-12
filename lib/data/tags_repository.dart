import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/data/barbershop_tags_api.dart';
import 'package:tagly/db/queries/tag_queries.dart';
import 'package:tagly/db/queries/video_queries.dart';
import 'package:tagly/db/tag_query_builder.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_search_query.dart';

enum SyncStatus {
  /// The app is syncing for the first time
  initialSync,

  /// There is a sync in progress
  resyncing,

  /// The sync has completed
  ready,
}

class TagsRepository extends ChangeNotifier {
  TagsRepository({
    required SharedPreferences preferences,
    required Database db,
    required BarbershopTagsApi api,
    required CacheManager cacheManager,
  }) : _preferences = preferences,
       _api = api,
       _db = db,
       _cacheManager = cacheManager;

  final Database _db;
  final BarbershopTagsApi _api;
  final CacheManager _cacheManager;
  final SharedPreferences _preferences;

  SyncStatus _syncStatus = .ready;
  SyncStatus get syncStatus => _syncStatus;

  static const lastSyncedKey = 'last_synced_timestamp';
  static const maxSyncFrequency = Duration(days: 1);

  /// Fetches the latest tags from the API and stores them in the database
  Future<Result<void>> syncTags() async {
    final countResult = await _db.rawQuery(TagQueries.count);
    final count = countResult.single['COUNT(DISTINCT id)']! as int;

    final lastSynced = switch (_preferences.getInt(lastSyncedKey)) {
      null => null,
      final value => DateTime.fromMillisecondsSinceEpoch(value),
    };

    final shouldSync =
        count == 0 ||
        lastSynced == null ||
        lastSynced.difference(DateTime.now()) > maxSyncFrequency;

    if (!shouldSync) {
      debugPrint('Skipping sync.');
      _syncStatus = .ready;
      return const .ok(null);
    }

    debugPrint('Syncing tags...');

    _syncStatus = switch (count) {
      0 => .initialSync,
      _ => .resyncing,
    };

    notifyListeners();

    try {
      // Calls the API to check how many tags are available.
      final tagsCountResponse = await _api.getTags(count: 1);

      final available = tagsCountResponse.available;

      debugPrint('$available tags found. Fetching...');

      final allTagsResponse = await _api.getTags(count: available);

      final batch = _db.batch();
      for (final tag in allTagsResponse.tags) {
        batch.rawInsert(TagQueries.upsert, tag.toMap().values.toList());
        for (final video in tag.videos) {
          batch.rawInsert(VideoQueries.upsert, video.toMap().values.toList());
        }
      }
      await batch.commit(noResult: true);

      await _preferences.setInt(
        lastSyncedKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      notifyListeners();
      return const .ok(null);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    } on DioException catch (e) {
      return .failure(e.message ?? 'Something went wrong.');
    } finally {
      _syncStatus = .ready;
    }
  }

  Future<Result<List<BarbershopTag>>> searchTags(TagSearchQuery query) async {
    try {
      final (sql, args) = TagQueryBuilder.build(query);
      final rows = await _db.rawQuery(sql, args);
      return .ok(BarbershopTag.groupRows(rows));
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<BarbershopTag>> getTagById(int id) async {
    try {
      final result = await _db.rawQuery(TagQueries.getById, [id]);

      final grouped = BarbershopTag.groupRows(result);

      if (grouped.length != 1) {
        return .failure('Tag $id not found');
      }

      return .ok(BarbershopTag.groupRows(result).single);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<List<BarbershopTag>>> getFavorites() async {
    try {
      final result = await _db.rawQuery(TagQueries.getFavorites);

      final grouped = BarbershopTag.groupRows(result);

      return .ok(grouped);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<void>> addToFavorites(int id) async {
    try {
      await _db.update(
        'tags',
        {'is_favorite': 1},
        where: 'id = ?',
        whereArgs: [id],
      );

      unawaited(cacheTag(id));

      return const .ok(null);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<void>> removeFromFavorites(int id) async {
    try {
      await _db.update(
        'tags',
        {'is_favorite': 0},
        where: 'id = ?',
        whereArgs: [id],
      );

      return const .ok(null);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<List<BarbershopTag>>> getTagsForList(int listId) async {
    try {
      final result = await _db.rawQuery(TagQueries.getByListId, [listId]);

      return .ok(BarbershopTag.groupRows(result));
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<void>> addTagToList({
    required int tagId,
    required int listId,
  }) async {
    try {
      await _db.insert('list_tags', {'tag_id': tagId, 'list_id': listId});
      unawaited(cacheTag(tagId));
      return const .ok(null);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<void>> removeTagFromList({
    required int tagId,
    required int listId,
  }) async {
    try {
      await _db.delete(
        'list_tags',
        where: 'tag_id = ? AND list_id = ?',
        whereArgs: [tagId, listId],
      );
      return const .ok(null);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<List<String>>> availableVoicings() async {
    try {
      final rows = await _db.rawQuery(
        '''SELECT DISTINCT type FROM tags WHERE type IS NOT NULL ORDER BY type''',
      );
      return .ok(rows.map((r) => r['type']! as String).toList());
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<void> cacheTag(int id) async {
    try {
      final tag = await getTagById(id);

      if (tag case Ok(:final value)) {
        final files = [
          ?value.sheetMusicUrl,
          ?value.allPartsUrl,
          ?value.tenorUrl,
          ?value.leadUrl,
          ?value.bariUrl,
          ?value.bassUrl,
          ?value.other1Url,
          ?value.other2Url,
          ?value.other3Url,
          ?value.other4Url,
        ];
        await Future.wait([
          for (final url in files) _cacheManager.downloadFile(url),
        ]);
      }
    } on Exception {
      return;
    }
  }
}
