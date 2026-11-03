import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/presentation/adaptive/two_pane.dart';

import '../../helpers/duo_poses.dart';

void main() {
  const primary = Key('primary');
  const secondary = Key('secondary');

  Widget pane(Key key) => Builder(
    builder: (context) => SizedBox.expand(
      key: key,
      child: Text('${MediaQuery.paddingOf(context)}'),
    ),
  );

  Future<void> pumpTwoPane(
    WidgetTester tester,
    Pose pose, {
    PaneArrangement arrangement = .split,
    bool showsSecondary = true,
  }) {
    return pumpPose(
      tester,
      pose,
      appBuilder: (builder) => testMaterialApp(
        builder: builder,
        home: TwoPane(
          arrangement: arrangement,
          showsSecondary: showsSecondary,
          primary: pane(primary),
          secondary: pane(secondary),
        ),
      ),
    );
  }

  group('split arrangement', () {
    testWidgets('splits horizontally when wider than tall', (tester) async {
      await pumpTwoPane(tester, innerLandscape);

      final p = tester.getRect(find.byKey(primary));
      final s = tester.getRect(find.byKey(secondary));
      expect(p.width, closeTo(innerLandscape.size.width * 0.4, 0.01));
      expect(s.left, p.right);
      expect(s.right, innerLandscape.size.width);
      expect(p.height, s.height);
    });

    testWidgets('splits vertically when taller than wide', (tester) async {
      await pumpTwoPane(tester, innerPortrait);

      final p = tester.getRect(find.byKey(primary));
      final s = tester.getRect(find.byKey(secondary));
      expect(p.width, s.width);
      expect(s.top, p.bottom);
    });

    testWidgets('resizes panes to clear the fold without reordering', (
      tester,
    ) async {
      await pumpTwoPane(tester, innerLandscape);
      final flat = tester.getRect(find.byKey(primary));

      await changePose(tester, innerLandscapeFolded);

      final p = tester.getRect(find.byKey(primary));
      final s = tester.getRect(find.byKey(secondary));
      expect(p.left, flat.left);
      expect(p.right, 455.5);
      expect(s.left, 495.5);
    });

    testWidgets('only outer edges keep their insets', (tester) async {
      await pumpTwoPane(tester, innerLandscape);

      expect(
        find.descendant(
          of: find.byKey(primary),
          matching: find.text('${const EdgeInsets.only(bottom: 34)}'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(secondary),
          matching: find.text('${innerLandscape.padding}'),
        ),
        findsOneWidget,
      );
    });
  });

  group('overlay arrangement', () {
    testWidgets('layers the primary over the secondary when flat', (
      tester,
    ) async {
      await pumpTwoPane(tester, innerLandscape, arrangement: .overlay);

      expect(
        tester.getRect(find.byKey(primary)),
        tester.getRect(find.byKey(secondary)),
      );
      final stack = tester.widget<Stack>(find.byType(Stack).first);
      expect((stack.children.last as Builder).key, isNull);
    });

    testWidgets('moves the views to each side of a partial fold', (
      tester,
    ) async {
      await pumpTwoPane(tester, innerLandscapeFolded, arrangement: .overlay);

      expect(tester.getRect(find.byKey(primary)).right, 455.5);
      expect(tester.getRect(find.byKey(secondary)).left, 495.5);
    });

    testWidgets('can collapse the secondary view', (tester) async {
      await pumpTwoPane(
        tester,
        innerLandscape,
        arrangement: .overlay,
        showsSecondary: false,
      );

      expect(find.byKey(secondary), findsNothing);
      expect(find.byKey(primary), findsOneWidget);
    });
  });

  group('isRegularLayout', () {
    for (final (pose, regular) in [
      (outer, false),
      (innerPortrait, true),
      (innerLandscape, true),
      (splitViewLeft, false),
      (splitViewRight, false),
      (standardIPhone, false),
      (const Pose('iPhone landscape', Size(852, 393), EdgeInsets.zero), false),
      (androidTablet, true),
    ]) {
      test('$pose is ${regular ? 'regular' : 'compact'}', () {
        expect(isRegularLayout(pose.size), regular);
      });
    }
  });
}
