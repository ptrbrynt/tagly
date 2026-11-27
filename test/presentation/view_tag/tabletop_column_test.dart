import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tagly/domain/fold.dart';
import 'package:tagly/presentation/view_tag/tabletop_column.dart';

const _content = Key('content');
const _controls = Key('controls');

void main() {
  group('TabletopColumn', () {
    Future<void> pump(WidgetTester tester, Fold? fold) async {
      tester.view
        ..physicalSize = const Size(400, 800)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        TabletopColumn(
          fold: fold,
          content: const SizedBox(key: _content),
          controls: ({required isTabletop}) =>
              SizedBox(key: _controls, height: isTabletop ? null : 100),
        ),
      );
      await tester.pump();
    }

    testWidgets('puts controls at the bottom without a fold', (tester) async {
      await pump(tester, null);

      expect(tester.getSize(find.byKey(_content)).height, 700);
      expect(tester.getTopLeft(find.byKey(_controls)).dy, 700);
    });

    testWidgets('splits content and controls around a horizontal fold', (
      tester,
    ) async {
      await pump(
        tester,
        const Fold(left: 0, top: 380, width: 400, height: 40, isActive: true),
      );

      expect(tester.getSize(find.byKey(_content)).height, 380);
      expect(tester.getTopLeft(find.byKey(_controls)).dy, 420);
      expect(tester.getBottomLeft(find.byKey(_controls)).dy, 800);
    });

    testWidgets('ignores a vertical fold', (tester) async {
      await pump(
        tester,
        const Fold(left: 180, top: 0, width: 40, height: 800, isActive: true),
      );

      expect(tester.getTopLeft(find.byKey(_controls)).dy, 700);
    });
  });
}
