import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tagly/domain/device_regions.dart';

import '../../helpers/duo_poses.dart';

void main() {
  late MediaQueryData mediaQuery;

  Future<BuildContext> pumpProbe(WidgetTester tester, Pose pose) async {
    late BuildContext probeContext;
    await pumpPose(
      tester,
      pose,
      appBuilder: (builder) => testMaterialApp(
        builder: builder,
        home: Builder(
          builder: (context) {
            probeContext = context;
            mediaQuery = MediaQuery.of(context);
            return const Scaffold();
          },
        ),
      ),
    );
    return probeContext;
  }

  testWidgets('a partial fold becomes a half-opened display feature', (
    tester,
  ) async {
    await pumpProbe(tester, innerLandscapeFolded);

    final fold = mediaQuery.displayFeatures.single;
    expect(fold.type, DisplayFeatureType.fold);
    expect(fold.state, DisplayFeatureState.postureHalfOpened);
    expect(fold.bounds, const Rect.fromLTWH(455.5, 0, 40, 669));
  });

  testWidgets('no regions means no display features or extra insets', (
    tester,
  ) async {
    await pumpProbe(tester, standardIPhone);

    expect(mediaQuery.displayFeatures, isEmpty);
    expect(mediaQuery.padding, standardIPhone.padding);
  });

  testWidgets('cameras inside the safe area push it inward', (tester) async {
    final activeInnerCamera = Pose(
      'inner portrait, camera active',
      innerPortrait.size,
      innerPortrait.padding,
      innerPortrait.regions.copyWith(
        regions: const [
          ReservedRegion(
            kind: .occlusion,
            left: 315,
            top: 86,
            width: 38,
            height: 38,
          ),
        ],
      ),
    );
    await pumpProbe(tester, activeInnerCamera);

    expect(mediaQuery.padding.top, 124);
    expect(mediaQuery.padding.bottom, innerPortrait.padding.bottom);
  });

  testWidgets('cameras already inside the bar column change nothing', (
    tester,
  ) async {
    await pumpProbe(tester, outer);

    expect(mediaQuery.padding, outer.padding);
  });

  testWidgets('dialogs open on one side of the fold', (tester) async {
    final context = await pumpProbe(tester, innerLandscapeFolded);

    showDialog<void>(
      context: context,
      builder: (_) => const AlertDialog(content: Text('Delete List?')),
    ).ignore();
    await tester.pumpAndSettle();

    final dialog = tester.getRect(find.byType(AlertDialog));
    expect(dialog.right, lessThanOrEqualTo(455.5));
  });

  testWidgets('bottom sheets open on one side of the fold', (tester) async {
    final context = await pumpProbe(tester, innerLandscapeFolded);

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (_) => const SizedBox(height: 200, child: Text('Filters')),
    ).ignore();
    await tester.pumpAndSettle();

    final sheet = tester.getRect(find.byType(BottomSheet));
    expect(sheet.right, lessThanOrEqualTo(455.5));
  });

  testWidgets('sheets stay clear of the vertical bar', (tester) async {
    final context = await pumpProbe(tester, outer);

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (_) => const SizedBox(height: 200, child: Text('Filters')),
    ).ignore();
    await tester.pumpAndSettle();

    expect(tester.getRect(find.text('Filters')).right, lessThanOrEqualTo(382));
  });
}
