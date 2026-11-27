import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tagly/domain/vertical_bar.dart';
import 'package:tagly/presentation/utils/vertical_bar_controls.dart';

// Measured on the iPhone Duo simulator, inner display in landscape: the
// status bar glyphs are centred at x = 903.
const _window = Size(951, 669);
const _rightBar = VerticalBar(
  edge: VerticalBarEdge.right,
  controls: ScreenRect(left: 879, top: 124, width: 48, height: 511),
);

const _favorite = Key('favorite');

void main() {
  group('VerticalBarScaffold', () {
    Future<void> pump(
      WidgetTester tester, {
      VerticalBar? verticalBar,
      bool reachesRight = true,
    }) async {
      tester.view
        ..physicalSize = _window
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final scaffold = VerticalBarScaffold(
        title: const Text('Popular Tags'),
        leading: BackButton(onPressed: () {}),
        actions: [
          IconButton(
            key: _favorite,
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
        body: const SizedBox.expand(),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: VerticalBarScope(
            verticalBar: verticalBar,
            child: reachesRight
                ? scaffold
                : WindowEdges(left: true, right: false, child: scaffold),
          ),
        ),
      );
    }

    testWidgets('uses a top bar without a vertical bar', (tester) async {
      await pump(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('centres controls on the vertical bar column', (tester) async {
      await pump(tester, verticalBar: _rightBar);

      expect(find.byType(AppBar), findsNothing);
      expect(find.text('Popular Tags'), findsOneWidget);
      expect(tester.getCenter(find.byType(BackButton)).dx, 903);
      expect(tester.getCenter(find.byKey(_favorite)).dx, 903);
    });

    testWidgets('stacks groups from the top of the column', (tester) async {
      await pump(tester, verticalBar: _rightBar);

      expect(tester.getTopLeft(find.byType(BackButton)).dy, 124);
      expect(
        tester.getTopLeft(find.byKey(_favorite)).dy,
        tester.getBottomLeft(find.byType(BackButton)).dy + 8,
      );
    });

    testWidgets('puts back and actions in separate tonal capsules', (
      tester,
    ) async {
      await pump(tester, verticalBar: _rightBar);

      Material capsuleOf(Finder control) => tester.widget<Material>(
        find.ancestor(
          of: control,
          matching: find.byWidgetPredicate(
            (widget) => widget is Material && widget.shape is StadiumBorder,
          ),
        ),
      );
      final back = capsuleOf(find.byType(BackButton));
      final actions = capsuleOf(find.byKey(_favorite));
      expect(back, isNot(same(actions)));
      final colors = Theme.of(tester.element(find.byKey(_favorite)))
          .colorScheme;
      expect(back.color, colors.surfaceContainerLowest);
      expect(actions.color, colors.surfaceContainerLowest);
    });

    testWidgets('nudges the side back chevron to look centred', (tester) async {
      await pump(tester, verticalBar: _rightBar);

      final chevron = find.byIcon(Icons.arrow_back_ios_new_rounded);
      expect(tester.getCenter(chevron).dx, 901.5);
      expect(tester.getCenter(find.byType(BackButton)).dx, 903);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('keeps a top bar in a pane away from the bar edge', (
      tester,
    ) async {
      await pump(tester, verticalBar: _rightBar, reachesRight: false);

      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
