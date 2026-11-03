import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/presentation/adaptive/tagly_scaffold.dart';
import 'package:tagly/presentation/adaptive/two_pane.dart';

import '../../helpers/duo_poses.dart';

void main() {
  BarItem item(
    String label, {
    BarItemPriority priority = .normal,
    int group = 0,
    BarItemRole role = .regular,
    bool showsBadge = false,
  }) => BarItem(
    label: label,
    icon: Icons.star_rounded,
    priority: priority,
    group: group,
    role: role,
    showsBadge: showsBadge,
    onPressed: () {},
  );

  final tagItems = [
    item('Favorite', priority: .high),
    item('Add to List', group: 1),
    item('Share', group: 1),
    item('Tag Details', priority: .low, group: 2),
    item('Open in Browser', priority: .low, group: 2),
  ];

  Future<void> pumpScaffold(
    WidgetTester tester,
    Pose pose, {
    List<BarItem>? items,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    return pumpPose(
      tester,
      pose,
      textDirection: textDirection,
      appBuilder: (builder) => MaterialApp(
        builder: builder,
        initialRoute: '/tag',
        routes: {
          '/': (_) => const TaglyScaffold(title: 'Home', body: SizedBox()),
          '/tag': (_) => TaglyScaffold(
            title: '#4696',
            items: items ?? tagItems,
            body: const SizedBox.expand(key: Key('body')),
          ),
        },
      ),
    );
  }

  Rect rectOf(WidgetTester tester, Finder finder) => tester.getRect(finder);
  Finder tooltip(String label) => find.byTooltip(label);

  group('bar placement', () {
    for (final textDirection in TextDirection.values) {
      for (final pose in [outer, innerLandscape, splitViewRight]) {
        testWidgets('$pose ($textDirection): vertical bar on the right', (
          tester,
        ) async {
          await pumpScaffold(tester, pose, textDirection: textDirection);

          expect(find.byType(AppBar), findsNothing);
          final barLeft = pose.size.width - pose.padding.right;
          expect(rectOf(tester, find.byType(BackButton)).left, barLeft + 18);
          expect(
            rectOf(tester, find.byKey(const Key('body'))).right,
            lessThanOrEqualTo(barLeft),
          );
        });
      }

      testWidgets('$splitViewLeft ($textDirection): bar on the app outer '
          'edge', (tester) async {
        await pumpScaffold(tester, splitViewLeft, textDirection: textDirection);

        expect(find.byType(AppBar), findsNothing);
        final back = rectOf(tester, find.byType(BackButton));
        expect(back.left, greaterThan(0));
        expect(back.top, 0);
        expect(
          rectOf(tester, find.byKey(const Key('body'))).left,
          greaterThanOrEqualTo(back.right),
        );
      });

      for (final pose in [innerPortrait, standardIPhone, androidTablet]) {
        testWidgets('$pose ($textDirection): standard app bar', (
          tester,
        ) async {
          await pumpScaffold(tester, pose, textDirection: textDirection);

          expect(find.byType(AppBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.byType(BackButton),
            ),
            findsOneWidget,
          );
          expect(find.text('#4696'), findsOneWidget);
        });
      }
    }

    for (final textDirection in TextDirection.values) {
      testWidgets('outer landscape ($textDirection): bar follows the camera '
          'to the left', (tester) async {
        await pumpScaffold(
          tester,
          outerLandscape,
          textDirection: textDirection,
        );

        final back = rectOf(tester, find.byType(BackButton));
        expect(back.right, lessThan(84));
        expect(back.top, 82);
        expect(
          rectOf(tester, find.byKey(const Key('body'))).left,
          greaterThanOrEqualTo(84),
        );
      });
    }

    testWidgets('controls start below the status area on the outer display', (
      tester,
    ) async {
      await pumpScaffold(tester, outer);

      expect(rectOf(tester, find.byType(BackButton)).top, 174);
    });

    testWidgets('title moves into the content when the bar is vertical', (
      tester,
    ) async {
      await pumpScaffold(tester, outer);

      final title = rectOf(tester, find.text('#4696'));
      expect(title.right, lessThanOrEqualTo(382));
    });

    testWidgets('a pane away from the bar edge keeps a top bar', (
      tester,
    ) async {
      await pumpPose(
        tester,
        innerLandscape,
        appBuilder: (builder) => testMaterialApp(
          builder: builder,
          home: TwoPane(
            allowedAxes: const {Axis.horizontal},
            primary: TaglyScaffold(
              title: 'List',
              items: [item('Filters')],
              body: const SizedBox(),
            ),
            secondary: TaglyScaffold(
              title: 'Detail',
              items: [item('Share')],
              body: const SizedBox(),
            ),
          ),
        ),
      );

      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);
      expect(
        find.descendant(of: appBar, matching: tooltip('Filters')),
        findsOneWidget,
      );
      expect(
        rectOf(tester, tooltip('Share')).left,
        greaterThan(innerLandscape.size.width - innerLandscape.padding.right),
      );
    });
  });

  group('item order', () {
    testWidgets('Back first, then prominent actions, then groups in order', (
      tester,
    ) async {
      await pumpScaffold(
        tester,
        innerLandscape,
        items: [
          item('Filters'),
          item('Done', role: .prominent),
          item('Share', group: 1),
        ],
      );

      final tops = [
        rectOf(tester, find.byType(BackButton)).top,
        rectOf(tester, tooltip('Done')).top,
        rectOf(tester, tooltip('Filters')).top,
        rectOf(tester, tooltip('Share')).top,
      ];
      expect(tops, orderedEquals([...tops]..sort()));
    });

    testWidgets('groups are separated by more space than items', (
      tester,
    ) async {
      await pumpScaffold(tester, innerLandscape);

      double gap(String a, String b) =>
          rectOf(tester, tooltip(b)).top - rectOf(tester, tooltip(a)).bottom;
      expect(
        gap('Add to List', 'Share'),
        lessThan(gap('Favorite', 'Add to List')),
      );
    });

    testWidgets('every item has a title as its tooltip', (tester) async {
      await pumpScaffold(tester, innerLandscape);

      for (final item in tagItems) {
        expect(tooltip(item.label), findsOneWidget);
      }
    });
  });

  group('overflow', () {
    final shortOuter = Pose(
      'short outer',
      const Size(466, 360),
      outer.padding,
      outer.regions,
    );

    testWidgets('everything fits on the outer display', (tester) async {
      await pumpScaffold(tester, outer);

      expect(tooltip('More'), findsNothing);
      expect(tooltip('Open in Browser'), findsOneWidget);
    });

    testWidgets('high-priority items stay, the rest move into one menu', (
      tester,
    ) async {
      await pumpScaffold(tester, shortOuter);

      expect(tooltip('Favorite'), findsOneWidget);
      expect(tooltip('More'), findsOneWidget);
      expect(tooltip('Open in Browser'), findsNothing);

      await tester.tap(tooltip('More'));
      await tester.pumpAndSettle();

      for (final label in [
        'Add to List',
        'Share',
        'Tag Details',
        'Open in Browser',
      ]) {
        expect(find.widgetWithText(MenuItemButton, label), findsOneWidget);
      }
      expect(find.byIcon(Icons.more_horiz_rounded), findsOneWidget);
    });

    testWidgets('items overflow from the bottom when priorities match', (
      tester,
    ) async {
      await pumpScaffold(
        tester,
        shortOuter,
        items: [item('First'), item('Second'), item('Third')],
      );

      expect(tooltip('First'), findsOneWidget);
      expect(tooltip('Third'), findsNothing);
    });

    testWidgets('badged items stay visible longer', (tester) async {
      await pumpScaffold(
        tester,
        shortOuter,
        items: [
          item('First'),
          item('Filters', showsBadge: true),
          item('Third'),
        ],
      );

      expect(tooltip('Filters'), findsOneWidget);
      expect(tooltip('First'), findsNothing);
    });

    testWidgets('a narrow app bar overflows to one ellipsis menu', (
      tester,
    ) async {
      await pumpScaffold(tester, standardIPhone);

      expect(tooltip('Favorite'), findsOneWidget);
      expect(tooltip('Open in Browser'), findsNothing);
      expect(find.byIcon(Icons.more_horiz_rounded), findsOneWidget);
      expect(find.byIcon(Icons.more_vert_rounded), findsNothing);
    });
  });
}
