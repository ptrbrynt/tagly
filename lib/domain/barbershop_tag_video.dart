import 'package:freezed_annotation/freezed_annotation.dart';

part 'barbershop_tag_video.freezed.dart';
part 'barbershop_tag_video.g.dart';

@freezed
abstract class BarbershopTagVideo with _$BarbershopTagVideo {
  const BarbershopTagVideo._();

  const factory BarbershopTagVideo({
    required int id,
    required int tagId,
    String? description,
    String? sungKeyMode,
    String? sungKeyTonic,
    @Default(false) bool isMultitrack,
    String? youtubeCode,
    String? facebookUrl,
    String? sungBy,
    String? sungWebsite,
    String? posted,
  }) = _BarbershopTagVideo;

  factory BarbershopTagVideo.fromJson(Map<String, dynamic> json) =>
      _$BarbershopTagVideoFromJson(json);

  factory BarbershopTagVideo.fromMap(Map<String, dynamic> map) =>
      BarbershopTagVideo(
        id: map['id'] as int,
        tagId: map['tag_id'] as int,
        description: map['description'] as String?,
        sungKeyMode: map['sung_key_mode'] as String?,
        sungKeyTonic: map['sung_key_tonic'] as String?,
        isMultitrack: (map['is_multitrack'] as int? ?? 0) == 1,
        youtubeCode: map['youtube_code'] as String?,
        facebookUrl: map['facebook_url'] as String?,
        sungBy: map['sung_by'] as String?,
        sungWebsite: map['sung_website'] as String?,
        posted: map['posted'] as String?,
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'tag_id': tagId,
    'description': description,
    'sung_key_mode': sungKeyMode,
    'sung_key_tonic': sungKeyTonic,
    'is_multitrack': isMultitrack ? 1 : 0,
    'youtube_code': youtubeCode,
    'facebook_url': facebookUrl,
    'sung_by': sungBy,
    'sung_website': sungWebsite,
    'posted': posted,
  };
}
