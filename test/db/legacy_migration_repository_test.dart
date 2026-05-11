import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/db/legacy/legacy_migration_repository.dart';

import '../helpers/test_db.dart';
import '../helpers/test_legacy_db.dart';

void main() {
  group('LegacyMigrationRepository', () {
    late Database legacyDb;
    late Database newDb;
    late LegacyMigrationRepository repo;

    setUp(() async {
      legacyDb = await openTestLegacyDb();
      newDb = await openTestDb();
      repo = LegacyMigrationRepository(
        legacyDatabase: legacyDb,
        newDatabase: newDb,
      );
    });

    tearDown(() async {
      await legacyDb.close();
      await newDb.close();
    });

    test(
      'migrate() with empty my_lists leaves new database unchanged',
      () async {
        await repo.migrate();

        final lists = await newDb.query('lists');
        final listTags = await newDb.query('list_tags');

        expect(lists, isEmpty);
        expect(listTags, isEmpty);
      },
    );

    test('migrate() creates a list for each my_lists row', () async {
      await legacyDb.insert('my_lists', {
        'name': 'Favourites',
        'tags': '[]',
      });
      await legacyDb.insert('my_lists', {
        'name': 'Competition Set',
        'tags': '[]',
      });

      await repo.migrate();

      final lists = await newDb.query('lists');

      expect(lists, hasLength(2));
      expect(
        lists.map((r) => r['name']),
        containsAll(['Favourites', 'Competition Set']),
      );
    });

    test('migrate() handles a list with no tags', () async {
      await legacyDb.insert('my_lists', {'name': 'Empty List', 'tags': '[]'});

      await repo.migrate();

      final lists = await newDb.query('lists');
      final listTags = await newDb.query('list_tags');

      expect(lists, hasLength(1));
      expect(lists.first['name'], equals('Empty List'));
      expect(listTags, isEmpty);
    });

    test(
      'migrate() creates list_tags for each tag referenced by a list',
      () async {
        await seedTestDb(newDb);
        await legacyDb.insert('my_lists', {
          'name': 'My List',
          'tags': '[{"id": 1482}, {"id": 7131}]',
        });

        await repo.migrate();

        final lists = await newDb.query('lists');
        final listId = lists.first['id']! as int;
        final listTags = await newDb.query(
          'list_tags',
          where: 'list_id = ?',
          whereArgs: [listId],
        );

        expect(listTags, hasLength(2));
        expect(
          listTags.map((r) => r['tag_id']),
          containsAll([1482, 7131]),
        );
      },
    );

    test('migrate() clears my_lists after migration', () async {
      await legacyDb.insert('my_lists', {'name': 'My List', 'tags': '[]'});

      await repo.migrate();

      final remaining = await legacyDb.query('my_lists');
      expect(remaining, isEmpty);
    });

    test('migrate() handles multiple lists with different tags', () async {
      await seedTestDb(newDb);
      await legacyDb.insert('my_lists', {
        'name': 'List A',
        'tags': '[{"id": 1482}, {"id": 7131}]',
      });
      await legacyDb.insert('my_lists', {
        'name': 'List B',
        'tags': '[{"id": 7346}]',
      });

      await repo.migrate();

      final lists = await newDb.query('lists');
      expect(lists, hasLength(2));

      final listAId =
          lists.firstWhere((r) => r['name'] == 'List A')['id']! as int;
      final listBId =
          lists.firstWhere((r) => r['name'] == 'List B')['id']! as int;

      final listATags = await newDb.query(
        'list_tags',
        where: 'list_id = ?',
        whereArgs: [listAId],
      );
      final listBTags = await newDb.query(
        'list_tags',
        where: 'list_id = ?',
        whereArgs: [listBId],
      );

      expect(
        listATags.map((r) => r['tag_id']),
        containsAll([1482, 7131]),
      );
      expect(listBTags.map((r) => r['tag_id']), containsAll([7346]));
    });
  });
}
