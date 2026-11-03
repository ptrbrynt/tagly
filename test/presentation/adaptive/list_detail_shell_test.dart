import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tagly/presentation/adaptive/list_detail_shell.dart';
import 'package:tagly/presentation/adaptive/tagly_scaffold.dart';

import '../../helpers/duo_poses.dart';

void main() {
  late GoRouter router;

  setUp(() {
    final listKey = GlobalKey();
    const list = _Counter(label: 'list', key: Key('list'));
    router = GoRouter(
      initialLocation: '/items',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const TaglyScaffold(body: Text('home')),
          routes: [
            ShellRoute(
              builder: (context, state, child) => ListDetailShell(
                listKey: listKey,
                list: list,
                detailNavigator: child,
              ),
              routes: [
                GoRoute(
                  path: 'items',
                  builder: (_, _) => ListDetailPage(
                    listKey: listKey,
                    list: list,
                    emptyDetailMessage: 'Select an item',
                  ),
                  routes: [
                    GoRoute(
                      path: 'item',
                      pageBuilder: (_, state) => DetailPanePage(
                        key: state.pageKey,
                        child: const DetailPaneRoot(
                          child: _Counter(label: 'detail', key: Key('detail')),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  });

  tearDown(() => router.dispose());

  Future<void> pumpShell(
    WidgetTester tester,
    Pose pose, {
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    await pumpPose(
      tester,
      pose,
      textDirection: textDirection,
      appBuilder: (builder) =>
          MaterialApp.router(routerConfig: router, builder: builder),
    );
    await tester.pumpAndSettle();
  }

  Future<void> increment(WidgetTester tester, String label) async {
    await tester.tap(find.byTooltip('Increment $label'));
    await tester.pump();
  }

  bool visible(String text) =>
      find.text(text).hitTestable().evaluate().isNotEmpty;

  testWidgets('compact shows one level at a time', (tester) async {
    await pumpShell(tester, outer);
    expect(visible('list 0'), isTrue);

    router.go('/items/item');
    await tester.pumpAndSettle();

    expect(visible('detail 0'), isTrue);
    expect(visible('list 0'), isFalse);
    expect(find.byType(BackButton).hitTestable(), findsOneWidget);
  });

  testWidgets('regular shows the list beside the detail', (tester) async {
    await pumpShell(tester, innerLandscape);
    expect(visible('list 0'), isTrue);
    expect(visible('Select an item'), isTrue);

    router.go('/items/item');
    await tester.pumpAndSettle();

    expect(visible('list 0'), isTrue);
    expect(visible('detail 0'), isTrue);
    final list = tester.getRect(find.byKey(const Key('list')));
    final detail = tester.getRect(find.byKey(const Key('detail')));
    expect(detail.left, greaterThanOrEqualTo(list.right));
  });

  testWidgets('the detail has no Back button while its list is beside it', (
    tester,
  ) async {
    await pumpShell(tester, innerLandscape);
    router.go('/items/item');
    await tester.pumpAndSettle();

    final detailBack = find.descendant(
      of: find.ancestor(
        of: find.byKey(const Key('detail')),
        matching: find.byType(TaglyScaffold),
      ),
      matching: find.byType(BackButton),
    );
    expect(detailBack, findsNothing);
  });

  for (final textDirection in TextDirection.values) {
    testWidgets('state survives opening, folding and closing '
        '($textDirection)', (tester) async {
      await pumpShell(tester, outer, textDirection: textDirection);
      await increment(tester, 'list');
      router.go('/items/item');
      await tester.pumpAndSettle();
      await increment(tester, 'detail');
      await increment(tester, 'detail');
      final detailState = tester.state(find.byKey(const Key('detail')));

      await changePose(tester, innerLandscape);
      expect(visible('list 1'), isTrue);
      expect(visible('detail 2'), isTrue);

      await changePose(tester, innerLandscapeFolded);
      expect(visible('list 1'), isTrue);
      expect(visible('detail 2'), isTrue);
      expect(
        tester.getRect(find.byKey(const Key('detail'))).left,
        greaterThanOrEqualTo(495.5),
      );

      await changePose(tester, outer);
      expect(visible('detail 2'), isTrue);
      expect(tester.state(find.byKey(const Key('detail'))), same(detailState));

      await tester.tap(find.byType(BackButton).hitTestable());
      await tester.pumpAndSettle();
      expect(visible('list 1'), isTrue);
    });
  }

  for (final pose in [splitViewLeft, splitViewRight]) {
    testWidgets('$pose stays compact with one pane', (tester) async {
      await pumpShell(tester, pose);
      router.go('/items/item');
      await tester.pumpAndSettle();

      expect(visible('detail 0'), isTrue);
      expect(visible('list 0'), isFalse);
    });
  }
}

class _Counter extends StatefulWidget {
  const new({required this.label, super.key});

  final String label;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return TaglyScaffold(
      title: widget.label,
      items: [
        BarItem(
          label: 'Increment ${widget.label}',
          icon: Icons.add_rounded,
          onPressed: () => setState(() => _count++),
        ),
      ],
      body: Center(child: Text('${widget.label} $_count')),
    );
  }
}
