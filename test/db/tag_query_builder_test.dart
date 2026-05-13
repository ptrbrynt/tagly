import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/db/tag_query_builder.dart';
import 'package:tagly/domain/tag_search_query.dart';

void main() {
  group('TagQueryBuilder', () {
    group('no filters', () {
      test('produces no WHERE clause and uses default sort', () {
        final (sql, args) = TagQueryBuilder.build(const TagSearchQuery());

        expect(sql, isNot(contains('WHERE')));
        expect(sql, contains('ORDER BY tags.downloaded DESC'));
        expect(args, isEmpty);
      });
    });

    group('text search', () {
      test('wraps text in FTS MATCH with prefix wildcard', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(text: 'i hear you sing'),
        );

        expect(sql, contains('WITH matched_ids AS'));
        expect(sql, contains('tags_fts MATCH ?'));
        expect(args.first, '"i hear you sing"*');
      });

      test('trims whitespace before wrapping', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(text: '  hello  '),
        );

        expect(args.first, '"hello"*');
      });

      test('escapes embedded double quotes', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(text: 'say "hello"'),
        );

        expect(args.first, '"say ""hello"""*');
      });

      test('whitespace-only text is treated as no text filter', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(text: '   '),
        );

        expect(sql, isNot(contains('WITH matched_ids')));
        expect(args, isEmpty);
      });
    });

    group('numeric text (exact ID)', () {
      test('uses CTE with UNION for FTS + exact ID', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(text: '4696'),
        );

        expect(sql, contains('UNION'));
        expect(args[0], '"4696"*');
        expect(args[1], 4696);
      });
    });

    group('voicings filter', () {
      test('single voicing uses = ?', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(voicings: ['Barbershop']),
        );

        expect(sql, contains('tags.type = ?'));
        expect(args, contains('Barbershop'));
      });

      test('multiple voicings uses IN (?, ?)', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(voicings: ['Barbershop', 'Mixed']),
        );

        expect(sql, contains('tags.type IN (?, ?)'));
        expect(args, containsAll(['Barbershop', 'Mixed']));
      });

      test('empty voicings list produces no clause', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(voicings: []),
        );

        expect(sql, isNot(contains('tags.type')));
        expect(args, isEmpty);
      });
    });

    group('numParts filter', () {
      test('single value uses = ?', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(numParts: [4]),
        );

        expect(sql, contains('tags.parts = ?'));
        expect(args, contains(4));
      });

      test('multiple values uses IN', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(numParts: [3, 4, 5]),
        );

        expect(sql, contains('tags.parts IN (?, ?, ?)'));
        expect(args, containsAll([3, 4, 5]));
      });
    });

    group('isClassic filter', () {
      test('true maps to 1', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(isClassic: true),
        );

        expect(sql, contains('tags.is_classic = ?'));
        expect(args, contains(1));
      });

      test('false maps to 0', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(isClassic: false),
        );

        expect(sql, contains('tags.is_classic = ?'));
        expect(args, contains(0));
      });

      test('null produces no clause', () {
        final (sql, _) = TagQueryBuilder.build(const TagSearchQuery());

        expect(sql, isNot(contains('is_classic')));
      });
    });

    group('limit', () {
      test('appends LIMIT clause and arg when set', () {
        final (sql, args) = TagQueryBuilder.build(
          const TagSearchQuery(limit: 20),
        );

        expect(sql, contains('LIMIT ?'));
        expect(args.last, 20);
      });

      test('no LIMIT clause when null', () {
        final (sql, _) = TagQueryBuilder.build(const TagSearchQuery());

        expect(sql, isNot(contains('LIMIT')));
      });
    });

    group('sort order', () {
      test('titleAsc', () {
        final (sql, _) = TagQueryBuilder.build(
          const TagSearchQuery(sortOrder: TagSortOrder.titleAsc),
        );
        expect(sql, contains('ORDER BY tags.title ASC'));
      });

      test('dateDesc', () {
        final (sql, _) = TagQueryBuilder.build(
          const TagSearchQuery(sortOrder: TagSortOrder.dateDesc),
        );
        expect(sql, contains('ORDER BY tags.posted DESC'));
      });

      test('downloadsDesc (default)', () {
        final (sql, _) = TagQueryBuilder.build(const TagSearchQuery());
        expect(sql, contains('ORDER BY tags.downloaded DESC'));
      });

      test('ratingDesc', () {
        final (sql, _) = TagQueryBuilder.build(
          const TagSearchQuery(sortOrder: TagSortOrder.ratingDesc),
        );
        expect(sql, contains('ORDER BY tags.rating DESC'));
      });

      test('id', () {
        final (sql, _) = TagQueryBuilder.build(
          const TagSearchQuery(sortOrder: TagSortOrder.id),
        );
        expect(sql, contains('ORDER BY tags.id ASC'));
      });
    });

    group('arg ordering', () {
      test('CTE args precede filter args', () {
        final (_, args) = TagQueryBuilder.build(
          const TagSearchQuery(
            text: 'hello',
            voicings: ['Barbershop'],
            isClassic: true,
            limit: 10,
          ),
        );

        // FTS arg first, then voicing, then isClassic, then limit
        expect(args[0], '"hello"*');
        expect(args[1], 'Barbershop');
        expect(args[2], 1);
        expect(args[3], 10);
      });
    });

    group('combined filters', () {
      test('all filters produce correct WHERE with AND', () {
        final (sql, _) = TagQueryBuilder.build(
          const TagSearchQuery(
            voicings: ['Barbershop'],
            numParts: [4],
            isClassic: true,
          ),
        );

        expect(sql, contains('AND'));
        expect(sql, contains('tags.type = ?'));
        expect(sql, contains('tags.parts = ?'));
        expect(sql, contains('tags.is_classic = ?'));
      });
    });
  });
}
