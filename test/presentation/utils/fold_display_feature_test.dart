import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tagly/domain/fold.dart';
import 'package:tagly/presentation/utils/fold_display_feature.dart';

const _window = Size(951, 669);

// Measured on the iPhone Duo simulator, partly folded.
const _bookFold = Fold(
  left: 439.5,
  top: 0,
  width: 72,
  height: 669,
  isActive: true,
);
const _tabletopFold = Fold(
  left: 0,
  top: 298.5,
  width: 951,
  height: 72,
  isActive: true,
);

void main() {
  group('FoldDisplayFeature', () {
    Future<void> pump(WidgetTester tester, Fold? fold) async {
      tester.view
        ..physicalSize = _window
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              FoldDisplayFeature(fold: fold, child: child!),
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    anchorPoint: foldAwareAnchor(context),
                    builder: (_) => const SizedBox(height: 200),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    }

    testWidgets('centres a sheet across the window without a fold', (
      tester,
    ) async {
      await pump(tester, null);

      final sheet = tester.getRect(find.byType(BottomSheet));
      expect(sheet.center.dx, _window.width / 2);
      expect(sheet.left, lessThan(_bookFold.left));
    });

    testWidgets('puts a sheet on the trailing page of a book fold', (
      tester,
    ) async {
      await pump(tester, _bookFold);

      final sheet = tester.getRect(find.byType(BottomSheet));
      expect(sheet.left, greaterThanOrEqualTo(_bookFold.right));
      expect(sheet.right, lessThanOrEqualTo(_window.width));
    });

    testWidgets('puts a sheet on the base of a tabletop fold', (tester) async {
      await pump(tester, _tabletopFold);

      final sheet = tester.getRect(find.byType(BottomSheet));
      expect(sheet.top, greaterThanOrEqualTo(_tabletopFold.bottom));
      expect(sheet.bottom, _window.height);
    });

    testWidgets('ignores a fold that is not active', (tester) async {
      await pump(tester, _bookFold.copyWith(isActive: false));

      expect(
        tester.getRect(find.byType(BottomSheet)).center.dx,
        _window.width / 2,
      );
    });
  });
}

extension on Fold {
  double get right => left + width;
}
