import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:tagly/domain/device_regions.dart';

/// Makes the device's reserved regions available below it and folds them
/// into [MediaQuery], so standard dialogs, sheets and menus avoid the fold
/// and content insets clear any camera the safe area doesn't already cover.
class DeviceRegionsScope extends StatelessWidget {
  const DeviceRegionsScope({
    required this.regions,
    required this.child,
    super.key,
  });

  final DeviceRegions regions;
  final Widget child;

  static DeviceRegions of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_DeviceRegionsInherited>()
          ?.regions ??
      const DeviceRegions();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return _DeviceRegionsInherited(
      regions: regions,
      child: MediaQuery(
        data: mediaQuery.copyWith(
          padding: _clearOcclusions(mediaQuery.padding, mediaQuery.size),
          viewPadding: _clearOcclusions(
            mediaQuery.viewPadding,
            mediaQuery.size,
          ),
          displayFeatures: [
            ...mediaQuery.displayFeatures,
            for (final region in regions.regions)
              if (region.kind == .division) _fold(region),
          ],
        ),
        child: child,
      ),
    );
  }

  DisplayFeature _fold(ReservedRegion region) => DisplayFeature(
    bounds: region.rect,
    type: .fold,
    state: regions.hinge?.status == .partiallyOpen
        ? .postureHalfOpened
        : .postureFlat,
  );

  EdgeInsets _clearOcclusions(EdgeInsets padding, Size size) {
    var result = padding;
    for (final region in regions.regions) {
      if (region.kind != .occlusion) continue;
      final rect = region.rect;
      final safe = Rect.fromLTRB(
        result.left,
        result.top,
        size.width - result.right,
        size.height - result.bottom,
      );
      if (!rect.overlaps(safe)) continue;
      // Push the nearest edge inward just far enough to clear the region.
      final (edge, inset) = <(AxisDirection, double)>[
        (.left, rect.right),
        (.up, rect.bottom),
        (.right, size.width - rect.left),
        (.down, size.height - rect.top),
      ].reduce((a, b) => a.$2 <= b.$2 ? a : b);
      result = switch (edge) {
        .left => result.copyWith(left: math.max(result.left, inset)),
        .up => result.copyWith(top: math.max(result.top, inset)),
        .right => result.copyWith(right: math.max(result.right, inset)),
        .down => result.copyWith(bottom: math.max(result.bottom, inset)),
      };
    }
    return result;
  }
}

class _DeviceRegionsInherited extends InheritedWidget {
  const _DeviceRegionsInherited({required this.regions, required super.child});

  final DeviceRegions regions;

  @override
  bool updateShouldNotify(_DeviceRegionsInherited oldWidget) =>
      regions != oldWidget.regions;
}

extension ReservedRegionRect on ReservedRegion {
  Rect get rect => Rect.fromLTWH(left, top, width, height);
}
