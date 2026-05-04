abstract final class TagQueries {
  // Columns shared by getAll / search / searchByArranger — tags.* plus
  // all tag_videos columns prefixed tv_ so they survive the JOIN without
  // clashing with the tags columns of the same name (e.g. sung_by, posted).
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

  static const getAll =
      '''
    SELECT tags.*, $_videoColumns
    FROM tags
    JOIN tags_fts ON tags.id = tags_fts.rowid
    $_videoJoin
''';

  static const getById =
      '''
    SELECT tags.*, $_videoColumns
    FROM tags
    WHERE id = ?
    JOIN tags_fts ON tags.id = tags_fts.rowid
    $_videoJoin
''';
  // --- Full-text search ---

  static const search =
      '''
    SELECT tags.*, $_videoColumns
    FROM tags
    JOIN tags_fts ON tags.id = tags_fts.rowid
    $_videoJoin
    WHERE tags_fts MATCH ?
    ORDER BY rank
  ''';

  static const searchByArranger =
      '''
    SELECT tags.*, $_videoColumns
    FROM tags
    JOIN tags_fts ON tags.id = tags_fts.rowid
    $_videoJoin
    WHERE tags_fts MATCH 'arranger:' || ?
    ORDER BY rank
  ''';

  // --- Upsert ---

  static const upsert = //language=SQL
  '''
    INSERT INTO tags (
      id, title, alt_title, version,
      key_mode, key_tonic, parts, type,
      recording, teach_vid_url, lyrics, notes,
      arranger, arr_website, arranged_year,
      sung_by, sung_website, sung_year,
      quartet, quartet_website,
      teacher, teacher_website,
      provider, provider_website,
      posted, is_classic, collection,
      rating, rating_count, downloaded, last_updated,
      sheet_music_url, sheet_music_type,
      notation_url, notation_type,
      all_parts_url, bass_url, bari_url, lead_url, tenor_url
    ) VALUES (
      ?, ?, ?, ?,
      ?, ?, ?, ?,
      ?, ?, ?, ?,
      ?, ?, ?,
      ?, ?, ?,
      ?, ?,
      ?, ?,
      ?, ?,
      ?, ?, ?,
      ?, ?, ?, ?,
      ?, ?,
      ?, ?,
      ?, ?, ?, ?, ?
    )
    ON CONFLICT(id) DO UPDATE SET
      title             = excluded.title,
      alt_title         = excluded.alt_title,
      version           = excluded.version,
      key_mode          = excluded.key_mode,
      key_tonic         = excluded.key_tonic,
      parts             = excluded.parts,
      type              = excluded.type,
      recording         = excluded.recording,
      teach_vid_url     = excluded.teach_vid_url,
      lyrics            = excluded.lyrics,
      notes             = excluded.notes,
      arranger          = excluded.arranger,
      arr_website       = excluded.arr_website,
      arranged_year     = excluded.arranged_year,
      sung_by           = excluded.sung_by,
      sung_website      = excluded.sung_website,
      sung_year         = excluded.sung_year,
      quartet           = excluded.quartet,
      quartet_website   = excluded.quartet_website,
      teacher           = excluded.teacher,
      teacher_website   = excluded.teacher_website,
      provider          = excluded.provider,
      provider_website  = excluded.provider_website,
      posted            = excluded.posted,
      is_classic        = excluded.is_classic,
      collection        = excluded.collection,
      rating            = excluded.rating,
      rating_count      = excluded.rating_count,
      downloaded        = excluded.downloaded,
      last_updated      = excluded.last_updated,
      sheet_music_url   = excluded.sheet_music_url,
      sheet_music_type  = excluded.sheet_music_type,
      notation_url      = excluded.notation_url,
      notation_type     = excluded.notation_type,
      all_parts_url     = excluded.all_parts_url,
      bass_url          = excluded.bass_url,
      bari_url          = excluded.bari_url,
      lead_url          = excluded.lead_url,
      tenor_url         = excluded.tenor_url
  ''';

  // --- Filtered listing ---

  static const byType = '''
    SELECT * FROM tags
    WHERE type = ?
    ORDER BY rating DESC
  ''';
}
