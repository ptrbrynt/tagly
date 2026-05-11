import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/data/lists_repository.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_list.dart';

import '../helpers/test_db.dart';

void main() {
  group('lists repository', () {
    late Database db;
    late ListsRepository repository;

    setUp(() async {
      db = await openTestDb();
      repository = ListsRepository(db: db);
    });

    tearDown(() async {
      await db.close();
    });

    test('getLists returns lists', () async {
      await db.insert('lists', {'name': 'My List'});
      await db.insert('lists', {'name': 'My Other List'});

      final result = await repository.getLists();

      expect(
        result,
        isA<Ok<List<TagList>>>().having(
          (result) {
            return result.value.map((l) => l.name);
          },
          'value',
          containsAll(['My List', 'My Other List']),
        ),
      );
    });

    test('createList inserts new list', () async {
      await repository.createList('My List');

      final rows = await db.query('lists');

      expect(rows.first['name'], equals('My List'));
    });

    test('deleteList deletes list', () async {
      final id = await db.insert('lists', {'name': 'My List'});

      await repository.deleteList(id);

      final rows = await db.query('lists');

      expect(rows, isEmpty);
    });

    test('renameList renames list', () async {
      final id = await db.insert('lists', {'name': 'My List'});

      await repository.renameList(id: id, name: 'My New List');

      final rows = await db.query('lists');

      expect(rows.first['name'], equals('My New List'));
    });
  });
}
