import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/data/tags_sync_repository.dart';
import 'package:tagly/data/tags_xml_parser.dart';
import 'package:tagly/db/queries/tag_queries.dart';
import 'package:tagly/domain/barbershop_tag.dart';

import '../fakes/fake_barbershop_tags_api.dart';
import '../helpers/fake_tags.dart';
import '../helpers/test_db.dart';

void main() {
  group('TagsSyncRepository', () {
    late MockBarbershopTagsApi api;
    late Database db;
    late TagsSyncRepository repository;

    setUp(() async {
      api = MockBarbershopTagsApi();
      db = await openTestDb();
      repository = TagsSyncRepository(db: db, api: api);
    });

    tearDown(() async {
      await db.close();
    });

    test('syncs tags', () async {
      when(() => api.getTags(count: 1)).thenAnswer((_) async {
        return TagsResponse(
          available: 6710,
          count: 1,
          stamp: DateFormat('YYYY-MM-DD HH:mm:ss').format(DateTime.now()),
          tags: [fakeTag],
        );
      });

      when(() => api.getTags(count: any(named: "count"))).thenAnswer((_) async {
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
          .then(
            (rows) => rows.map((row) => BarbershopTag.fromMap(row)).toList(),
          );

      // TODO Make this assertion more robust
      expect(dbTags.map((t) => t.id), containsAll(fakeTags.map((t) => t.id)));
    });
  });
}
