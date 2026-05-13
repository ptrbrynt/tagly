import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/domain/tag_search_query.dart';

void main() {
  group('TagSearchQuery', () {
    group('exactId', () {
      test('returns null when text is null', () {
        expect(const TagSearchQuery().exactId, isNull);
      });

      test('returns null for non-numeric text', () {
        expect(
          const TagSearchQuery(text: 'i hear you sing').exactId,
          isNull,
        );
      });

      test('returns parsed int for numeric text', () {
        expect(const TagSearchQuery(text: '4696').exactId, 4696);
      });

      test('returns null for text that is a partial number', () {
        expect(const TagSearchQuery(text: '123abc').exactId, isNull);
      });
    });

    group('hasFilters', () {
      test('returns false for a bare default query', () {
        expect(const TagSearchQuery().hasFilters, isFalse);
      });

      test('returns false when only text is set', () {
        expect(const TagSearchQuery(text: 'hello').hasFilters, isFalse);
      });

      test('returns true when voicings are set', () {
        expect(
          const TagSearchQuery(voicings: ['Barbershop']).hasFilters,
          isTrue,
        );
      });

      test('returns true when numParts is set', () {
        expect(const TagSearchQuery(numParts: [4]).hasFilters, isTrue);
      });

      test('returns true when sortOrder differs from default', () {
        expect(
          const TagSearchQuery(sortOrder: TagSortOrder.titleAsc).hasFilters,
          isTrue,
        );
      });

      test('returns false for empty voicings and numParts lists', () {
        expect(
          const TagSearchQuery(voicings: [], numParts: []).hasFilters,
          isFalse,
        );
      });
    });

    group('asQueryParameters / fromQueryParameters round-trip', () {
      test('round-trips text', () {
        const original = TagSearchQuery(text: 'i hear you sing');
        final encoded = original.asQueryParameters();
        final decoded = TagSearchQuery.fromQueryParameters(
          _split(encoded),
        );
        expect(decoded.text, original.text);
      });

      test('round-trips voicings', () {
        const original = TagSearchQuery(voicings: ['Barbershop', 'Mixed']);
        final decoded = TagSearchQuery.fromQueryParameters(
          _split(original.asQueryParameters()),
        );
        expect(decoded.voicings, original.voicings);
      });

      test('round-trips numParts', () {
        const original = TagSearchQuery(numParts: [3, 4]);
        final decoded = TagSearchQuery.fromQueryParameters(
          _split(original.asQueryParameters()),
        );
        expect(decoded.numParts, original.numParts);
      });

      test('round-trips sortOrder', () {
        const original = TagSearchQuery(sortOrder: TagSortOrder.titleAsc);
        final decoded = TagSearchQuery.fromQueryParameters(
          _split(original.asQueryParameters()),
        );
        expect(decoded.sortOrder, TagSortOrder.titleAsc);
      });

      test('round-trips limit', () {
        const original = TagSearchQuery(limit: 20);
        final decoded = TagSearchQuery.fromQueryParameters(
          _split(original.asQueryParameters()),
        );
        expect(decoded.limit, 20);
      });

      test('round-trips isClassic true', () {
        const original = TagSearchQuery(isClassic: true);
        final decoded = TagSearchQuery.fromQueryParameters(
          _split(original.asQueryParameters()),
        );
        expect(decoded.isClassic, isTrue);
      });

      test('round-trips isClassic false', () {
        const original = TagSearchQuery(isClassic: false);
        final decoded = TagSearchQuery.fromQueryParameters(
          _split(original.asQueryParameters()),
        );
        expect(decoded.isClassic, isFalse);
      });

      test('omits null text from query string', () {
        expect(const TagSearchQuery().asQueryParameters(), isNot(contains('text=')));
      });

      test('omits null limit from query string', () {
        expect(const TagSearchQuery().asQueryParameters(), isNot(contains('limit=')));
      });

      test('omits null isClassic from query string', () {
        expect(const TagSearchQuery().asQueryParameters(), isNot(contains('isClassic=')));
      });
    });
  });
}

/// Parses a flat query string like `"a=1&b[]=x&b[]=y"` into the
/// `Map<String, List<String>>` format that [TagSearchQuery.fromQueryParameters] expects.
Map<String, List<String>> _split(String qs) {
  final result = <String, List<String>>{};
  for (final pair in qs.split('&')) {
    if (pair.isEmpty) continue;
    final idx = pair.indexOf('=');
    final key = pair.substring(0, idx);
    final value = pair.substring(idx + 1);
    result.putIfAbsent(key, () => []).add(value);
  }
  return result;
}
