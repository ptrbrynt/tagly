abstract final class VideoQueries {
  // --- Fetching ---

  static const byTagId = //language=SQL
  '''
    SELECT * FROM tag_videos
    WHERE tag_id = ?
  ''';

  // --- Upsert ---

  static const upsert = //language=SQL
  '''
    INSERT INTO tag_videos (
      id, tag_id, description,
      sung_key_mode, sung_key_tonic, is_multitrack,
      youtube_code, facebook_url,
      sung_by, sung_website, posted
    ) VALUES (
      ?, ?, ?,
      ?, ?, ?,
      ?, ?,
      ?, ?, ?
    )
    ON CONFLICT(id) DO UPDATE SET
      tag_id        = excluded.tag_id,
      description   = excluded.description,
      sung_key_mode = excluded.sung_key_mode,
      sung_key_tonic= excluded.sung_key_tonic,
      is_multitrack = excluded.is_multitrack,
      youtube_code  = excluded.youtube_code,
      facebook_url  = excluded.facebook_url,
      sung_by       = excluded.sung_by,
      sung_website  = excluded.sung_website,
      posted        = excluded.posted
  ''';
}
