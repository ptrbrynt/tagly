import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/data/barbershop_tags_api.dart';
import 'package:tagly/db/queries/tag_queries.dart';
import 'package:tagly/db/queries/video_queries.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

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
    required Database db,
    required BarbershopTagsApi api,
    required CacheManager cacheManager,
  }) : _api = api,
       _db = db,
       _cacheManager = cacheManager;

  final Database _db;
  final BarbershopTagsApi _api;
  final CacheManager _cacheManager;

  SyncStatus _syncStatus = .ready;
  SyncStatus get syncStatus => _syncStatus;

  /// Fetches the latest tags from the API and stores them in the database
  Future<Result<void>> syncTags() async {
    debugPrint('Syncing tags...');
    final countResult = await _db.rawQuery(TagQueries.count);
    final count = countResult.single['COUNT(DISTINCT id)']! as int;

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

  Future<Result<List<BarbershopTag>>> searchTags(String query) async {
    try {
      final sanitized = _buildFtsQuery(query);
      if (sanitized == null) return const .ok([]);

      final id = int.tryParse(query);
      final rows = await _db.rawQuery(
        TagQueries.searchByTextOrId,
        [sanitized, id],
      );
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

  /// Sanitises a raw user search string into a safe FTS5 MATCH expression.
  ///
  /// - Strips characters with special meaning in FTS5 query syntax.
  /// - Appends `*` to each token for prefix (autocomplete-style) matching.
  ///
  /// Returns null if the input is blank after sanitisation, so the caller
  /// can skip the query entirely and return an empty result set.
  String? _buildFtsQuery(String input) {
    // Strip FTS5 special characters
    final cleaned = input.replaceAll(RegExp(r'["\(\)\^\*:\-]'), ' ');

    final tokens = cleaned
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    if (tokens.isEmpty) return null;

    // Each token becomes a prefix query: "barb shop" → "barb* shop*"
    return tokens.map((t) => '$t*').join(' ');
  }
}
