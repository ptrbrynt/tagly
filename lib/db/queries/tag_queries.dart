abstract final class TagQueries {
  // --- Full-text search ---

  static const search = '''
    SELECT tags.*
    FROM tags
    JOIN tags_fts ON tags.id = tags_fts.rowid
    WHERE tags_fts MATCH ?
    ORDER BY rank
  ''';

  static const searchByArranger = '''
    SELECT tags.*
    FROM tags
    JOIN tags_fts ON tags.id = tags_fts.rowid
    WHERE tags_fts MATCH 'arranger:' || ?
    ORDER BY rank
  ''';

  // --- Filtered listing ---

  static const byType = '''
    SELECT * FROM tags
    WHERE type = ?
    ORDER BY rating DESC
  ''';
}
