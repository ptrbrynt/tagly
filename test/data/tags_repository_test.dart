import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/data/tags_xml_parser.dart';
import 'package:tagly/db/queries/tag_queries.dart';
import 'package:tagly/db/queries/video_queries.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

import '../fakes/fake_barbershop_tags_api.dart';
import '../helpers/fake_tags.dart';
import '../helpers/test_db.dart';

void main() {
  group('TagsRepository', () {
    late MockBarbershopTagsApi api;
    late Database db;
    late TagsRepository repository;

    setUp(() async {
      api = MockBarbershopTagsApi();
      db = await openTestDb();
      repository = TagsRepository(db: db, api: api);
    });

    tearDown(() async {
      await db.close();
    });

    test('syncTags saves tags from API to DB', () async {
      when(() => api.getTags(count: 1)).thenAnswer((_) async {
        return TagsResponse(
          available: 6710,
          count: 1,
          stamp: DateFormat('YYYY-MM-DD HH:mm:ss').format(DateTime.now()),
          tags: [fakeTag],
        );
      });

      when(() => api.getTags(count: any(named: 'count'))).thenAnswer((_) async {
        return TagsResponse(
          available: 6710,
          count: fakeTags.length,
          stamp: DateFormat('YYYY-MM-DD HH:mm:ss').format(DateTime.now()),
          tags: fakeTags,
        );
      });

      await repository.syncTags();

      final dbTags = await db
          .rawQuery(TagQueries.getAll)
          .then(BarbershopTag.groupRows);

      expect(dbTags, unorderedEquals(fakeTags));
    });

    test('search correctly searches', () async {
      await _seedDb(db);

      final searchResult = await repository.searchTags('hear you sing');

      expect(
        searchResult,
        isA<Ok<List<BarbershopTag>>>().having(
          (r) => r.value,
          'results',
          isNotEmpty,
        ),
      );
    });

    test('search by ID correctly searches', () async {
      await _seedDb(db);

      final searchResult = await repository.searchTags('${fakeTags.first.id}');

      expect(
        searchResult,
        isA<Ok<List<BarbershopTag>>>().having(
          (r) => r.value.single,
          'single result',
          equals(fakeTags.first),
        ),
      );
    });

    test('empty search query returns empty result', () async {
      await _seedDb(db);

      final searchResult = await repository.searchTags('');

      expect(
        searchResult,
        isA<Ok<List<BarbershopTag>>>().having(
          (r) => r.value,
          'results',
          isEmpty,
        ),
      );
    });

    test('get by ID returns correct tag', () async {
      await _seedDb(db);

      final result = await repository.getTagById(fakeTags.first.id);

      expect(result, equals(Ok(fakeTags.first)));
    });

    test('get by ID returns failure when tag does not exist', () async {
      await _seedDb(db);

      final result = await repository.getTagById(10987);

      expect(result, isA<Failure<Result<BarbershopTag>>>());
    });
  });
}

Future<void> _seedDb(Database db) async {
  final batch = db.batch();
  for (final tag in fakeTags) {
    batch.rawInsert(TagQueries.upsert, tag.toMap().values.toList());
    for (final video in tag.videos) {
      batch.rawInsert(VideoQueries.upsert, video.toMap().values.toList());
    }
  }
  await batch.commit(noResult: true);
}
