import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagly/domain/barbershop_tag_video.dart';

part 'barbershop_tag.freezed.dart';
part 'barbershop_tag.g.dart';

@freezed
abstract class BarbershopTag with _$BarbershopTag {
  const factory BarbershopTag({
    required int id,
    required String title,
    String? altTitle,
    String? version,
    String? keyMode,
    String? keyTonic,
    int? parts,
    String? type,
    String? recording,
    String? teachVidUrl,
    String? lyrics,
    String? notes,
    String? arranger,
    String? arrWebsite,
    int? arrangedYear,
    String? sungBy,
    String? sungWebsite,
    int? sungYear,
    String? quartet,
    String? quartetWebsite,
    String? teacher,
    String? teacherWebsite,
    String? provider,
    String? providerWebsite,
    String? posted,
    @Default(false) bool isClassic,
    String? collection,
    double? rating,
    int? ratingCount,
    int? downloaded,
    String? lastUpdated,
    String? sheetMusicUrl,
    String? sheetMusicType,
    String? notationUrl,
    String? notationType,
    String? allPartsUrl,
    String? bassUrl,
    String? bariUrl,
    String? leadUrl,
    String? tenorUrl,
    String? other1Url,
    String? other2Url,
    String? other3Url,
    String? other4Url,
    // Not a column in the tags table — populated by the repository
    // when fetching a single tag with its related videos.
    @Default([]) List<BarbershopTagVideo> videos,
    @JsonKey(toJson: boolToInt, fromJson: boolFromInt)
    @Default(false)
    bool isFavorite,
  }) = _BarbershopTag;

  /// Construct from a sqflite row. When using a query that JOINs tag_videos,
  /// use [groupRows] instead — it handles collapsing the duplicated rows.
  factory BarbershopTag.fromMap(
    Map<String, dynamic> map, {
    List<BarbershopTagVideo> videos = const [],
  }) => BarbershopTag(
    id: map['id'] as int,
    title: map['title'] as String,
    altTitle: map['alt_title'] as String?,
    version: map['version'] as String?,
    keyMode: map['key_mode'] as String?,
    keyTonic: map['key_tonic'] as String?,
    // Defensive num cast — SQLite's flexible type system means an
    // INTEGER column can occasionally surface as num in Dart.
    parts: (map['parts'] as num?)?.toInt(),
    type: map['type'] as String?,
    recording: map['recording'] as String?,
    teachVidUrl: map['teach_vid_url'] as String?,
    lyrics: map['lyrics'] as String?,
    notes: map['notes'] as String?,
    arranger: map['arranger'] as String?,
    arrWebsite: map['arr_website'] as String?,
    arrangedYear: (map['arranged_year'] as num?)?.toInt(),
    sungBy: map['sung_by'] as String?,
    sungWebsite: map['sung_website'] as String?,
    sungYear: (map['sung_year'] as num?)?.toInt(),
    quartet: map['quartet'] as String?,
    quartetWebsite: map['quartet_website'] as String?,
    teacher: map['teacher'] as String?,
    teacherWebsite: map['teacher_website'] as String?,
    provider: map['provider'] as String?,
    providerWebsite: map['provider_website'] as String?,
    posted: map['posted'] as String?,
    isClassic: (map['is_classic'] as int? ?? 0) == 1,
    collection: map['collection'] as String?,
    rating: (map['rating'] as num?)?.toDouble(),
    ratingCount: (map['rating_count'] as num?)?.toInt(),
    downloaded: (map['downloaded'] as num?)?.toInt(),
    lastUpdated: map['last_updated'] as String?,
    sheetMusicUrl: map['sheet_music_url'] as String?,
    sheetMusicType: map['sheet_music_type'] as String?,
    notationUrl: map['notation_url'] as String?,
    notationType: map['notation_type'] as String?,
    allPartsUrl: map['all_parts_url'] as String?,
    bassUrl: map['bass_url'] as String?,
    bariUrl: map['bari_url'] as String?,
    leadUrl: map['lead_url'] as String?,
    tenorUrl: map['tenor_url'] as String?,
    other1Url: map['other_1_url'] as String?,
    other2Url: map['other_2_url'] as String?,
    other3Url: map['other_3_url'] as String?,
    other4Url: map['other_4_url'] as String?,
    videos: videos,
    isFavorite: boolFromInt(map['is_favorite'] as int? ?? 0),
  );
  const BarbershopTag._();

  factory BarbershopTag.fromJson(Map<String, dynamic> json) =>
      _$BarbershopTagFromJson(json);

  /// Collapse a list of joined rows (from a query that LEFT JOINs tag_videos
  /// using `tv_` prefixed columns) into a list of tags, each with its videos
  /// populated. Preserves the row order of the first occurrence of each tag.
  static List<BarbershopTag> groupRows(List<Map<String, dynamic>> rows) {
    final tagRows = <int, Map<String, dynamic>>{};
    final videosByTag = <int, List<BarbershopTagVideo>>{};

    for (final row in rows) {
      final tagId = row['id'] as int;
      tagRows.putIfAbsent(tagId, () => row);

      final tvId = row['tv_id'];
      if (tvId != null) {
        videosByTag
            .putIfAbsent(tagId, () => [])
            .add(
              BarbershopTagVideo(
                id: tvId as int,
                tagId: tagId,
                description: row['tv_description'] as String?,
                sungKeyMode: row['tv_sung_key_mode'] as String?,
                sungKeyTonic: row['tv_sung_key_tonic'] as String?,
                isMultitrack: (row['tv_is_multitrack'] as int? ?? 0) == 1,
                youtubeCode: row['tv_youtube_code'] as String?,
                facebookUrl: row['tv_facebook_url'] as String?,
                sungBy: row['tv_sung_by'] as String?,
                sungWebsite: row['tv_sung_website'] as String?,
                posted: row['tv_posted'] as String?,
              ),
            );
      }
    }

    return tagRows.entries.map(
      (e) {
        return BarbershopTag.fromMap(e.value, videos: videosByTag[e.key] ?? []);
      },
    ).toList();
  }

  /// Serialise to a sqflite row map.
  ///
  /// [videos] is intentionally excluded — those rows are managed
  /// separately in the `tag_videos` table.
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'alt_title': altTitle,
    'version': version,
    'key_mode': keyMode,
    'key_tonic': keyTonic,
    'parts': parts,
    'type': type,
    'recording': recording,
    'teach_vid_url': teachVidUrl,
    'lyrics': lyrics,
    'notes': notes,
    'arranger': arranger,
    'arr_website': arrWebsite,
    'arranged_year': arrangedYear,
    'sung_by': sungBy,
    'sung_website': sungWebsite,
    'sung_year': sungYear,
    'quartet': quartet,
    'quartet_website': quartetWebsite,
    'teacher': teacher,
    'teacher_website': teacherWebsite,
    'provider': provider,
    'provider_website': providerWebsite,
    'posted': posted,
    'is_classic': isClassic ? 1 : 0,
    'collection': collection,
    'rating': rating,
    'rating_count': ratingCount,
    'downloaded': downloaded,
    'last_updated': lastUpdated,
    'sheet_music_url': sheetMusicUrl,
    'sheet_music_type': sheetMusicType,
    'notation_url': notationUrl,
    'notation_type': notationType,
    'all_parts_url': allPartsUrl,
    'bass_url': bassUrl,
    'bari_url': bariUrl,
    'lead_url': leadUrl,
    'tenor_url': tenorUrl,
    'other_1_url': other1Url,
    'other_2_url': other2Url,
    'other_3_url': other3Url,
    'other_4_url': other4Url,
    'is_favorite': boolToInt(isFavorite),
  };

  String? get keyName {
    return switch ((keyTonic, keyMode)) {
      (null, _) || (_, null) => null,
      (final String tonic, final String mode) => '$tonic $mode',
    };
  }

  Map<String, String> get learningTracks {
    return {
      'Full Mix': ?allPartsUrl,
      'Tenor': ?tenorUrl,
      'Lead': ?leadUrl,
      'Baritone': ?bariUrl,
      'Bass': ?bassUrl,
      'Other 1': ?other1Url,
      'Other 2': ?other2Url,
      'Other 3': ?other3Url,
      'Other 4': ?other4Url,
    };
  }

  Uri get tagUri {
    final path = StringBuffer('tag-$id-$title');
    if (version != null && version!.isNotEmpty) {
      path.write('-($version)');
    }
    return Uri(
      scheme: 'https',
      host: 'www.barbershoptags.com',
      path: path.toString().replaceAll(' ', '-'),
    );
  }

  Uri get deepLink {
    return Uri.parse('tagly://tag?id=$id');
  }
}

bool boolFromInt(int value) => value != 0;

// ignore: avoid_positional_boolean_parameters
int boolToInt(bool value) => value ? 1 : 0;
