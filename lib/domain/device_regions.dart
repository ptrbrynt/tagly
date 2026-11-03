import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_regions.freezed.dart';
part 'device_regions.g.dart';

/// The physical side of the display that hosts vertical bars. Hardware
/// aligned, so it never flips for right-to-left languages.
enum BarSide { left, right }

enum HingeStatus { unknown, closed, partiallyOpen, fullyOpen }

enum ReservedRegionKind {
  /// Areas content shouldn't cover, such as a front-facing camera.
  occlusion,

  /// Areas that divide the display into separate usable regions: the fold.
  division,
}

@freezed
abstract class ReservedRegion with _$ReservedRegion {
  const factory({
    required ReservedRegionKind kind,
    required double left,
    required double top,
    required double width,
    required double height,
  }) = _ReservedRegion;

  factory fromJson(Map<String, dynamic> json) => _$ReservedRegionFromJson(json);
}

@freezed
abstract class Hinge with _$Hinge {
  const factory({required HingeStatus status, required double angle}) = _Hinge;

  factory fromJson(Map<String, dynamic> json) => _$HingeFromJson(json);
}

@freezed
abstract class DeviceRegions with _$DeviceRegions {
  const factory({
    @Default(<ReservedRegion>[]) List<ReservedRegion> regions,
    BarSide? barSide,
    Hinge? hinge,
  }) = _DeviceRegions;

  factory fromJson(Map<String, dynamic> json) => _$DeviceRegionsFromJson(json);
}
