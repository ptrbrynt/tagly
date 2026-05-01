// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barbershop_tag_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BarbershopTagVideo _$BarbershopTagVideoFromJson(Map<String, dynamic> json) =>
    _BarbershopTagVideo(
      id: (json['id'] as num).toInt(),
      tagId: (json['tagId'] as num).toInt(),
      description: json['description'] as String?,
      sungKeyMode: json['sungKeyMode'] as String?,
      sungKeyTonic: json['sungKeyTonic'] as String?,
      isMultitrack: json['isMultitrack'] as bool? ?? false,
      youtubeCode: json['youtubeCode'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      sungBy: json['sungBy'] as String?,
      sungWebsite: json['sungWebsite'] as String?,
      posted: json['posted'] as String?,
    );

Map<String, dynamic> _$BarbershopTagVideoToJson(_BarbershopTagVideo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tagId': instance.tagId,
      'description': instance.description,
      'sungKeyMode': instance.sungKeyMode,
      'sungKeyTonic': instance.sungKeyTonic,
      'isMultitrack': instance.isMultitrack,
      'youtubeCode': instance.youtubeCode,
      'facebookUrl': instance.facebookUrl,
      'sungBy': instance.sungBy,
      'sungWebsite': instance.sungWebsite,
      'posted': instance.posted,
    };
