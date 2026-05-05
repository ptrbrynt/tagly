import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
  TagsRepository({required Database db, required BarbershopTagsApi api})
    : _api = api,
      _db = db;

  final Database _db;
  final BarbershopTagsApi _api;

  SyncStatus _syncStatus = .ready;
  SyncStatus get syncStatus => _syncStatus;

  /// Fetches the latest tags from the API and stores them in the database
  Future<Result<void>> syncTags() async {
    debugPrint('Syncing tags...');
    final countResult = await _db.rawQuery(TagQueries.count);
    final count = countResult.single['COUNT(DISTINCT id)'] as int;

    _syncStatus = switch (count) {
      0 => .initialSync,
      _ => .resyncing,
    };

    notifyListeners();

    try {
      // Calls the API to check how many tags are available.
      final tagsCountResponse = await _api.getTags(count: 1);

      var available = tagsCountResponse.available;

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
      return .ok(null);
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
      final searchResult = switch (_buildFtsQuery(query)) {
        null => <Map<String, dynamic>>[],
        final sanitized => await _db.rawQuery(TagQueries.search, [sanitized]),
      };

      final idResult = switch (int.tryParse(query)) {
        null => <Map<String, Object?>>[],
        final id => await _db.rawQuery(TagQueries.getById, [id]),
      };

      return .ok([
        ...BarbershopTag.groupRows(idResult),
        ...BarbershopTag.groupRows(searchResult),
      ]);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<BarbershopTag>> getTagById(int id) async {
    try {
      final result = await _db.rawQuery(TagQueries.getById, [id]);

      return .ok(BarbershopTag.groupRows(result).single);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    } on StateError {
      return .failure('Tag $id not found');
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
