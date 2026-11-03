// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_regions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReservedRegion _$ReservedRegionFromJson(Map<String, dynamic> json) =>
    _ReservedRegion(
      kind: $enumDecode(_$ReservedRegionKindEnumMap, json['kind']),
      left: (json['left'] as num).toDouble(),
      top: (json['top'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );

Map<String, dynamic> _$ReservedRegionToJson(_ReservedRegion instance) =>
    <String, dynamic>{
      'kind': _$ReservedRegionKindEnumMap[instance.kind]!,
      'left': instance.left,
      'top': instance.top,
      'width': instance.width,
      'height': instance.height,
    };

const _$ReservedRegionKindEnumMap = {
  ReservedRegionKind.occlusion: 'occlusion',
  ReservedRegionKind.division: 'division',
};

_Hinge _$HingeFromJson(Map<String, dynamic> json) => _Hinge(
  status: $enumDecode(_$HingeStatusEnumMap, json['status']),
  angle: (json['angle'] as num).toDouble(),
);

Map<String, dynamic> _$HingeToJson(_Hinge instance) => <String, dynamic>{
  'status': _$HingeStatusEnumMap[instance.status]!,
  'angle': instance.angle,
};

const _$HingeStatusEnumMap = {
  HingeStatus.unknown: 'unknown',
  HingeStatus.closed: 'closed',
  HingeStatus.partiallyOpen: 'partiallyOpen',
  HingeStatus.fullyOpen: 'fullyOpen',
};

_DeviceRegions _$DeviceRegionsFromJson(Map<String, dynamic> json) =>
    _DeviceRegions(
      regions:
          (json['regions'] as List<dynamic>?)
              ?.map((e) => ReservedRegion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReservedRegion>[],
      barSide: $enumDecodeNullable(_$BarSideEnumMap, json['barSide']),
      hinge: json['hinge'] == null
          ? null
          : Hinge.fromJson(json['hinge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeviceRegionsToJson(_DeviceRegions instance) =>
    <String, dynamic>{
      'regions': instance.regions,
      'barSide': _$BarSideEnumMap[instance.barSide],
      'hinge': instance.hinge,
    };

const _$BarSideEnumMap = {BarSide.left: 'left', BarSide.right: 'right'};
