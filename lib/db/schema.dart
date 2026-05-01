import 'package:sqflite/sqflite.dart';

abstract final class Schema {
  static const int version = 1;

  // ----------------------------------------------------------------
  // DDL statements
  // ----------------------------------------------------------------

  static const _createTags = //language=SQL
  '''
      CREATE TABLE IF NOT EXISTS tags (
        id                  INTEGER PRIMARY KEY,
        title               TEXT    NOT NULL,
        alt_title           TEXT,
        version             TEXT,

        -- WritKey split from e.g. "Major:C" into two filterable columns
        key_mode            TEXT,
        key_tonic           TEXT,

        parts               INTEGER,
        type                TEXT,
        recording           TEXT,
        teach_vid_url       TEXT,

        lyrics              TEXT,
        notes               TEXT,

        arranger            TEXT,
        arr_website         TEXT,
        arranged_year       INTEGER,
        sung_by             TEXT,
        sung_website        TEXT,
        sung_year           INTEGER,
        quartet             TEXT,
        quartet_website     TEXT,
        teacher             TEXT,
        teacher_website     TEXT,
        provider            TEXT,
        provider_website    TEXT,

        posted              TEXT,
        is_classic          INTEGER NOT NULL DEFAULT 0,
        collection          TEXT,
        rating              REAL,
        rating_count        INTEGER,
        downloaded          INTEGER,
        last_updated        TEXT,

        sheet_music_url     TEXT,
        sheet_music_type    TEXT,
        notation_url        TEXT,
        notation_type       TEXT,

        all_parts_url       TEXT,
        bass_url            TEXT,
        bari_url            TEXT,
        lead_url            TEXT,
        tenor_url           TEXT
      )
      ''';

  static const _createTagVideos = //language=SQL
  '''
      CREATE TABLE IF NOT EXISTS tag_videos (
        id                  INTEGER PRIMARY KEY,
        tag_id              INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
        description         TEXT,
        sung_key_mode       TEXT,
        sung_key_tonic      TEXT,
        is_multitrack       INTEGER NOT NULL DEFAULT 0,
        youtube_code        TEXT,
        facebook_url        TEXT,
        sung_by             TEXT,
        sung_website        TEXT,
        posted              TEXT
      )
      ''';

  // ----------------------------------------------------------------
  // Indexes
  // ----------------------------------------------------------------

  static const _createIndexType = //language=SQL
  '''
      CREATE INDEX IF NOT EXISTS idx_tags_type
        ON tags(type)
      ''';

  static const _createIndexKey = //language=SQL
  '''
      CREATE INDEX IF NOT EXISTS idx_tags_key
        ON tags(key_mode, key_tonic)
      ''';

  static const _createIndexParts = //language=SQL
  '''
      CREATE INDEX IF NOT EXISTS idx_tags_parts
        ON tags(parts)
      ''';

  static const _createIndexArrangedYear = //language=SQL
  '''
      CREATE INDEX IF NOT EXISTS idx_tags_arranged_year
        ON tags(arranged_year)
      ''';

  static const _createIndexRating = //language=SQL
  '''
      CREATE INDEX IF NOT EXISTS idx_tags_rating
        ON tags(rating DESC)
      ''';

  static const _createIndexPosted = //language=SQL
  '''
      CREATE INDEX IF NOT EXISTS idx_tags_posted
        ON tags(posted DESC)
      ''';

  static const _createIndexDownloaded = //language=SQL
  '''
      CREATE INDEX IF NOT EXISTS idx_tags_downloaded
        ON tags(downloaded DESC)
      ''';

  static const _createIndexVideoTagId = //language=SQL
  '''
      CREATE INDEX IF NOT EXISTS idx_tag_videos_tag_id
        ON tag_videos(tag_id)
      ''';

  // ----------------------------------------------------------------
  // FTS5 virtual table
  // ----------------------------------------------------------------

  static const _createFts = //language=SQL
  '''
      CREATE VIRTUAL TABLE IF NOT EXISTS tags_fts USING fts5(
        title,
        alt_title,
        lyrics,
        notes,
        arranger,
        sung_by,
        quartet,
        content       = tags,
        content_rowid = id
      )
      ''';

  // ----------------------------------------------------------------
  // FTS5 sync triggers
  // ----------------------------------------------------------------

  static const _createTriggerInsert = //language=SQL
  '''
      CREATE TRIGGER IF NOT EXISTS tags_ai
      AFTER INSERT ON tags BEGIN
        INSERT INTO tags_fts(rowid, title, alt_title, lyrics, notes, arranger, sung_by, quartet)
        VALUES (new.id, new.title, new.alt_title, new.lyrics, new.notes,
                new.arranger, new.sung_by, new.quartet);
      END
      ''';

  static const _createTriggerDelete = //language=SQL
  '''
      CREATE TRIGGER IF NOT EXISTS tags_ad
      AFTER DELETE ON tags BEGIN
        INSERT INTO tags_fts(tags_fts, rowid, title, alt_title, lyrics, notes, arranger, sung_by, quartet)
        VALUES ('delete', old.id, old.title, old.alt_title, old.lyrics, old.notes,
                old.arranger, old.sung_by, old.quartet);
      END
      ''';

  static const _createTriggerUpdate = //language=SQL
  '''
      CREATE TRIGGER IF NOT EXISTS tags_au
      AFTER UPDATE ON tags BEGIN
        INSERT INTO tags_fts(tags_fts, rowid, title, alt_title, lyrics, notes, arranger, sung_by, quartet)
        VALUES ('delete', old.id, old.title, old.alt_title, old.lyrics, old.notes,
                old.arranger, old.sung_by, old.quartet);
        INSERT INTO tags_fts(rowid, title, alt_title, lyrics, notes, arranger, sung_by, quartet)
        VALUES (new.id, new.title, new.alt_title, new.lyrics, new.notes,
                new.arranger, new.sung_by, new.quartet);
      END
      ''';

  // ----------------------------------------------------------------
  // Ordered list of all statements to execute on database creation
  // ----------------------------------------------------------------

  static const List<String> _statements = [
    // Tables first
    _createTags,
    _createTagVideos,
    // Indexes
    _createIndexType,
    _createIndexKey,
    _createIndexParts,
    _createIndexArrangedYear,
    _createIndexRating,
    _createIndexPosted,
    _createIndexDownloaded,
    _createIndexVideoTagId,
    // FTS5 virtual table and triggers last (depends on tags table)
    _createFts,
    _createTriggerInsert,
    _createTriggerDelete,
    _createTriggerUpdate,
  ];

  // ----------------------------------------------------------------
  // onCreate / onConfigure hooks to pass directly to openDatabase()
  // ----------------------------------------------------------------

  static Future<void> onConfigure(Database db) async {
    // Enable WAL mode for better concurrent read/write performance
    await db.execute('PRAGMA journal_mode = WAL');
    // Enable foreign key enforcement (off by default in SQLite)
    await db.execute('PRAGMA foreign_keys = ON');
  }

  static Future<void> onCreate(Database db, int version) async {
    for (final statement in _statements) {
      await db.execute(statement);
    }
  }
}
