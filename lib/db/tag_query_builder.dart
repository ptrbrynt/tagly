import 'package:tagly/domain/tag_search_query.dart';

abstract final class TagQueryBuilder {
  static const _videoColumns = '''
    tv.id               AS tv_id,
    tv.description      AS tv_description,
    tv.sung_key_mode    AS tv_sung_key_mode,
    tv.sung_key_tonic   AS tv_sung_key_tonic,
    tv.is_multitrack    AS tv_is_multitrack,
    tv.youtube_code     AS tv_youtube_code,
    tv.facebook_url     AS tv_facebook_url,
    tv.sung_by          AS tv_sung_by,
    tv.sung_website     AS tv_sung_website,
    tv.posted           AS tv_posted
  ''';

  static const _videoJoin = '''
    LEFT JOIN tag_videos tv ON tv.tag_id = tags.id
  ''';

  static (String, List<dynamic>) build(TagSearchQuery q) {
    final args = <dynamic>[];
    final outerWhere = <String>[];
    final sql = StringBuffer();

    final hasFts = q.text?.trim().isNotEmpty ?? false;
    final hasExactId = q.exactId != null;
    final hasCte = hasFts || hasExactId;

    // --- CTE (args added here come first, matching their position in SQL) ---
    if (hasCte) {
      sql.writeln('WITH matched_ids AS (');

      if (hasFts) {
        args.add(_prepareFtsQuery(q.text!));
        sql.write(
          '  SELECT rowid AS tag_id FROM tags_fts WHERE tags_fts MATCH ?',
        );

        if (hasExactId) {
          args.add(q.exactId);
          sql.write('\n  UNION\n  SELECT ?');
        }
      } else {
        // Exact ID only
        args.add(q.exactId);
        sql.write('  SELECT ?');
      }

      sql.writeln('\n)');
      outerWhere.add('tags.id IN (SELECT tag_id FROM matched_ids)');
    }

    _addMultiValue(outerWhere, args, 'tags.voicing', q.voicings);
    _addMultiValue(outerWhere, args, 'tags.num_parts', q.numParts);

    if (q.isClassic != null) {
      outerWhere.add('tags.is_classic = ?');
      args.add(q.isClassic! ? 1 : 0);
    }

    sql
      ..writeln('SELECT tags.*, $_videoColumns')
      ..writeln('FROM tags')
      ..writeln(_videoJoin);

    if (outerWhere.isNotEmpty) {
      sql.writeln('WHERE ${outerWhere.join('\n  AND ')}');
    }

    sql.write(_orderBy(q.sortOrder));
    if (q.limit != null) {
      sql.write(' LIMIT ?');
      args.add(q.limit);
    }
    return (sql.toString(), args);
  }

  static void _addMultiValue(
    List<String> clauses,
    List<dynamic> args,
    String column,
    List<dynamic>? values,
  ) {
    if (values == null || values.isEmpty) return;
    if (values.length == 1) {
      clauses.add('$column = ?');
      args.add(values.first);
    } else {
      final placeholders = List.filled(values.length, '?').join(', ');
      clauses.add('$column IN ($placeholders)');
      args.addAll(values);
    }
  }

  static String _orderBy(TagSortOrder order) => switch (order) {
    .titleAsc => ' ORDER BY tags.title ASC',
    .dateDesc => ' ORDER BY tags.posted DESC',
    .downloadsDesc => ' ORDER BY tags.downloaded DESC',
    .ratingDesc => ' ORDER BY tags.rating DESC',
    .id => ' ORDER BY tags.id ASC',
  };

  static String _prepareFtsQuery(String raw) {
    final trimmed = raw.trim();
    final escaped = trimmed.replaceAll('"', '""');
    return '"$escaped"*';
  }
}
