import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/config/theme.dart';
import 'package:tagly/domain/device_regions.dart';
import 'package:tagly/presentation/adaptive/device_regions_scope.dart';

/// A window size, its safe-area insets and the reserved regions iOS reports
/// for it.
class Pose {
  const Pose(
    this.name,
    this.size,
    this.padding, [
    this.regions = const DeviceRegions(),
  ]);

  final String name;
  final Size size;
  final EdgeInsets padding;
  final DeviceRegions regions;

  @override
  String toString() => name;
}

ReservedRegion _region(
  ReservedRegionKind kind,
  double left,
  double top,
  double width,
  double height,
) => ReservedRegion(
  kind: kind,
  left: left,
  top: top,
  width: width,
  height: height,
);

/// The outer display, measured on the iOS 27.1 iPhone Duo simulator.
final outer = Pose(
  'outer',
  const Size(466, 678),
  const EdgeInsets.only(right: 84, bottom: 34),
  DeviceRegions(
    barSide: .right,
    hinge: const Hinge(status: .closed, angle: 0),
    regions: [
      _region(.occlusion, 399.67, 29.33, 37, 37),
      _region(.occlusion, 382, 0, 84, 174),
    ],
  ),
);

/// The outer display in landscape: the bar follows the camera to the left.
final outerLandscape = Pose(
  'outer landscape',
  const Size(678, 466),
  const EdgeInsets.only(left: 84, bottom: 34),
  DeviceRegions(
    barSide: .left,
    hinge: const Hinge(status: .closed, angle: 0),
    regions: [
      _region(.occlusion, 29.33, 29.33, 37, 37),
      _region(.occlusion, 0, 0, 84, 82),
    ],
  ),
);

/// Inner display poses, measured in Device Hub on the iOS 27.1 simulator.
/// Hinge angles are in radians.
final innerPortrait = Pose(
  'inner portrait',
  const Size(669, 951),
  const EdgeInsets.only(top: 82, bottom: 34),
  DeviceRegions(
    hinge: const Hinge(status: .fullyOpen, angle: 3.14),
    regions: [_region(.occlusion, 807, 0, 144, 82)],
  ),
);

final innerLandscape = Pose(
  'inner landscape',
  const Size(951, 669),
  const EdgeInsets.only(right: 84, bottom: 34),
  DeviceRegions(
    barSide: .right,
    hinge: const Hinge(status: .fullyOpen, angle: 3.14),
    regions: [_region(.occlusion, 867, 0, 84, 124)],
  ),
);

final innerLandscapeFolded = Pose(
  'inner landscape, partially folded',
  innerLandscape.size,
  innerLandscape.padding,
  innerLandscape.regions.copyWith(
    hinge: const Hinge(status: .partiallyOpen, angle: 2.2),
    regions: [
      ...innerLandscape.regions.regions,
      _region(.division, 455.5, 0, 40, 669),
    ],
  ),
);

/// The left app's bar is on its outer (left) edge, but the system's status
/// column is only on the camera side, so the left app gets no inset for it.
const splitViewLeft = Pose(
  'Split View, left app',
  Size(469, 669),
  EdgeInsets.only(bottom: 34),
  DeviceRegions(
    barSide: .left,
    hinge: Hinge(status: .fullyOpen, angle: 3.14),
  ),
);

final splitViewRight = Pose(
  'Split View, right app',
  const Size(469, 669),
  const EdgeInsets.only(right: 84, bottom: 34),
  DeviceRegions(
    barSide: .right,
    hinge: const Hinge(status: .fullyOpen, angle: 3.14),
    regions: [_region(.occlusion, 385, 0, 84, 124)],
  ),
);

const standardIPhone = Pose(
  'standard iPhone',
  Size(393, 852),
  EdgeInsets.only(top: 59, bottom: 34),
);

const androidTablet = Pose(
  'Android tablet',
  Size(1280, 800),
  EdgeInsets.only(top: 24),
);

/// Sets the test window to [pose] and pumps the app from [appBuilder] with
/// the pose's regions.
Future<void> pumpPose(
  WidgetTester tester,
  Pose pose, {
  required Widget Function(TransitionBuilder builder) appBuilder,
  TextDirection textDirection = TextDirection.ltr,
}) async {
  setPose(tester, pose);
  await tester.pumpWidget(
    _PoseHost(
      pose: pose,
      textDirection: textDirection,
      appBuilder: appBuilder,
    ),
  );
}

/// Changes the window to [pose] without rebuilding the app, as when the
/// device opens, closes or folds.
Future<void> changePose(WidgetTester tester, Pose pose) async {
  setPose(tester, pose);
  tester.state<_PoseHostState>(find.byType(_PoseHost)).pose = pose;
  await tester.pump();
}

void setPose(WidgetTester tester, Pose pose) {
  const ratio = 3.0;
  tester.view
    ..devicePixelRatio = ratio
    ..physicalSize = pose.size * ratio
    ..padding = FakeViewPadding(
      left: pose.padding.left * ratio,
      top: pose.padding.top * ratio,
      right: pose.padding.right * ratio,
      bottom: pose.padding.bottom * ratio,
    )
    ..viewPadding = FakeViewPadding(
      left: pose.padding.left * ratio,
      top: pose.padding.top * ratio,
      right: pose.padding.right * ratio,
      bottom: pose.padding.bottom * ratio,
    );
  addTearDown(tester.view.reset);
}

Widget testMaterialApp({required Widget home, TransitionBuilder? builder}) =>
    MaterialApp(theme: lightTheme, builder: builder, home: home);

class _PoseHost extends StatefulWidget {
  const _PoseHost({
    required this.pose,
    required this.textDirection,
    required this.appBuilder,
  });

  final Pose pose;
  final TextDirection textDirection;
  final Widget Function(TransitionBuilder builder) appBuilder;

  @override
  State<_PoseHost> createState() => _PoseHostState();
}

class _PoseHostState extends State<_PoseHost> {
  late Pose _pose = widget.pose;
  Pose get pose => _pose;
  set pose(Pose value) => setState(() => _pose = value);

  late final Widget _app = widget.appBuilder(
    (context, child) => Directionality(
      textDirection: widget.textDirection,
      child: _RegionsFromPose(child: child!),
    ),
  );

  @override
  Widget build(BuildContext context) => _PoseRegions(pose: _pose, child: _app);
}

/// Lets the pose change while the app widget itself (and so all of its
/// state) stays the same.
class _PoseRegions extends InheritedWidget {
  const _PoseRegions({required this.pose, required super.child});

  final Pose pose;

  @override
  bool updateShouldNotify(_PoseRegions oldWidget) => pose != oldWidget.pose;
}

class _RegionsFromPose extends StatelessWidget {
  const _RegionsFromPose({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final pose = context
        .dependOnInheritedWidgetOfExactType<_PoseRegions>()!
        .pose;
    return DeviceRegionsScope(regions: pose.regions, child: child);
  }
}
