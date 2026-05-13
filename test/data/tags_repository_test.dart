import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/data/tags_xml_parser.dart';
import 'package:tagly/db/queries/tag_queries.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_search_query.dart';

import '../fakes/fake_barbershop_tags_api.dart';
import '../helpers/fake_cache_manager.dart';
import '../helpers/fake_shared_preferences.dart';
import '../helpers/fake_tags.dart';
import '../helpers/test_db.dart';

void main() {
  group('TagsRepository', () {
    late MockBarbershopTagsApi api;
    late Database db;
    late TagsRepository repository;
    late CacheManager cacheManager;
    late SharedPreferences preferences;

    setUp(() async {
      api = MockBarbershopTagsApi();
      db = await openTestDb();
      cacheManager = FakeCacheManager();
      preferences = FakeSharedPreferences();
      repository = TagsRepository(
        db: db,
        api: api,
        cacheManager: cacheManager,
        preferences: preferences,
      );
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

    test(
      '''syncTags does not sync when tags exist and lastSynced is within last 24 hours''',
      () async {
        await seedTestDb(db);

        await preferences.setInt(
          TagsRepository.lastSyncedKey,
          DateTime.now()
              .subtract(
                TagsRepository.maxSyncFrequency - const Duration(seconds: 1),
              )
              .millisecondsSinceEpoch,
        );

        when(() => api.getTags(count: 1)).thenAnswer(
          (_) async {
            return TagsResponse(
              available: 6710,
              count: 1,
              stamp: DateFormat('YYYY-MM-DD HH:mm:ss').format(DateTime.now()),
              tags: [fakeTag],
            );
          },
        );

        when(() => api.getTags(count: any(named: 'count'))).thenAnswer(
          (_) async {
            return TagsResponse(
              available: 6710,
              count: fakeTags.length,
              stamp: DateFormat('YYYY-MM-DD HH:mm:ss').format(DateTime.now()),
              tags: fakeTags,
            );
          },
        );

        await repository.syncTags();

        final dbTags = await db
            .rawQuery(TagQueries.getAll)
            .then(BarbershopTag.groupRows);

        expect(dbTags.length, equals(fakeTags.length));
      },
    );

    test(
      '''syncTags does sync when tags is empty and lastSynced is within last 24 hours''',
      () async {
        await preferences.setInt(
          TagsRepository.lastSyncedKey,
          DateTime.now()
              .subtract(const Duration(hours: 2))
              .millisecondsSinceEpoch,
        );

        when(() => api.getTags(count: 1)).thenAnswer(
          (_) async {
            return TagsResponse(
              available: 6710,
              count: 1,
              stamp: DateFormat('YYYY-MM-DD HH:mm:ss').format(DateTime.now()),
              tags: [fakeTag],
            );
          },
        );

        when(() => api.getTags(count: any(named: 'count'))).thenAnswer(
          (_) async {
            return TagsResponse(
              available: 6710,
              count: fakeTags.length,
              stamp: DateFormat('YYYY-MM-DD HH:mm:ss').format(DateTime.now()),
              tags: fakeTags,
            );
          },
        );

        await repository.syncTags();

        final dbTags = await db
            .rawQuery(TagQueries.getAll)
            .then(BarbershopTag.groupRows);

        expect(dbTags, unorderedEquals(fakeTags));
      },
    );

    test('search correctly searches', () async {
      await seedTestDb(db);

      final searchResult = await repository.searchTags(
        const TagSearchQuery(text: 'hear you sing'),
      );

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
      await seedTestDb(db);

      final searchResult = await repository.searchTags(
        TagSearchQuery(text: '${fakeTags.first.id}'),
      );

      expect(
        searchResult,
        isA<Ok<List<BarbershopTag>>>().having(
          (r) => r.value.single,
          'single result',
          equals(fakeTags.first),
        ),
      );
    });

    test('get by ID returns correct tag', () async {
      await seedTestDb(db);

      final result = await repository.getTagById(fakeTags.first.id);

      expect(result, equals(Ok(fakeTags.first)));
    });

    test('get by ID returns failure when tag does not exist', () async {
      await seedTestDb(db);

      final result = await repository.getTagById(10987);

      expect(result, isA<Failure<BarbershopTag>>());
    });

    test('getFavorites returns favorites', () async {
      await seedTestDb(db);

      await db.update(
        'tags',
        {'is_favorite': 1},
        where: 'id = ?',
        whereArgs: [fakeTags.first.id],
      );

      final result = await repository.getFavorites();

      expect(
        result,
        isA<Ok<List<BarbershopTag>>>().having(
          (r) => r.value.single,
          'single result',
          equals(fakeTags.first.copyWith(isFavorite: true)),
        ),
      );
    });

    test('addToFavorites marks tag as favorite', () async {
      await seedTestDb(db);

      await repository.addToFavorites(fakeTags.first.id);

      final tag = await db.query(
        'tags',
        where: 'id = ?',
        whereArgs: [fakeTags.first.id],
      );

      expect(tag.single['is_favorite'], equals(1));
    });

    test('syncTags preserves is_favorite through resync', () async {
      when(() => api.getTags(count: 1)).thenAnswer((_) async {
        return TagsResponse(
          available: fakeTags.length,
          count: 1,
          stamp: DateFormat('YYYY-MM-DD HH:mm:ss').format(DateTime.now()),
          tags: [fakeTag],
        );
      });

      when(() => api.getTags(count: any(named: 'count'))).thenAnswer((_) async {
        return TagsResponse(
          available: fakeTags.length,
          count: fakeTags.length,
          stamp: DateFormat('YYYY-MM-DD HH:mm:ss').format(DateTime.now()),
          tags: fakeTags,
        );
      });

      await repository.syncTags();
      await repository.addToFavorites(fakeTags.first.id);
      await repository.syncTags();

      final tag = await db.query(
        'tags',
        where: 'id = ?',
        whereArgs: [fakeTags.first.id],
      );

      expect(tag.single['is_favorite'], equals(1));
    });

    test('removeFromFavorites marks tag as favorite', () async {
      await seedTestDb(db);

      await db.update(
        'tags',
        {'is_favorite': 1},
        where: 'id = ?',
        whereArgs: [fakeTags.first.id],
      );

      await repository.removeFromFavorites(fakeTags.first.id);

      final tag = await db.query(
        'tags',
        where: 'id = ?',
        whereArgs: [fakeTags.first.id],
      );

      expect(tag.single['is_favorite'], equals(0));
    });

    test('getTagsFromList returns tags in a list', () async {
      await seedTestDb(db);

      final listId = await db.insert('lists', {'name': 'My List'});

      await db.insert('list_tags', {
        'list_id': listId,
        'tag_id': fakeTags.first.id,
      });

      await db.insert('list_tags', {
        'list_id': listId,
        'tag_id': fakeTags[1].id,
      });

      final result = await repository.getTagsForList(listId);

      expect(
        result,
        isA<Ok<List<BarbershopTag>>>().having(
          (result) => result.value.map((i) => i.id),
          'IDs',
          containsAll([fakeTags.first.id, fakeTags[1].id]),
        ),
      );
    });

    test('removeTagFromList removes tag from list but keeps others', () async {
      await seedTestDb(db);

      final listId = await db.insert('lists', {'name': 'My List'});

      await db.insert('list_tags', {
        'list_id': listId,
        'tag_id': fakeTags.first.id,
      });

      await db.insert('list_tags', {
        'list_id': listId,
        'tag_id': fakeTags[1].id,
      });

      await repository.removeTagFromList(
        tagId: fakeTags.first.id,
        listId: listId,
      );

      final result = await db.query(
        'list_tags',
        where: 'list_id = ?',
        whereArgs: [listId],
      );

      expect(result.length, equals(1));
    });

    test('addTagToList adds tag to list', () async {
      await seedTestDb(db);

      final listId = await db.insert('lists', {'name': 'My List'});

      await repository.addTagToList(tagId: fakeTags.first.id, listId: listId);

      final result = await db.query(
        'list_tags',
        where: 'list_id = ?',
        whereArgs: [listId],
      );

      expect(result.first['tag_id'], equals(fakeTags.first.id));
    });

    test('availableVoicings returns voicings', () async {
      await seedTestDb(db);

      final expected = fakeTags.map((i) => i.type).toSet();

      final result = await repository.availableVoicings();

      expect(
        result,
        isA<Ok<List<String>>>().having(
          (r) => r.value,
          'value',
          containsAll(expected),
        ),
      );
    });
  });
}
