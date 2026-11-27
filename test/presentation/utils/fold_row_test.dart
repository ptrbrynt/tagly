import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tagly/presentation/utils/fold_row.dart';

const _window = Size(951, 669);
const _start = Key('start');
const _end = Key('end');

// Measured on the iPhone Duo simulator, folded like a book.
const _bookFold = DisplayFeature(
  bounds: Rect.fromLTRB(455.5, 0, 495.5, 669),
  type: DisplayFeatureType.fold,
  state: DisplayFeatureState.postureHalfOpened,
);

void main() {
  group('FoldRow', () {
    Future<void> pump(
      WidgetTester tester, {
      List<DisplayFeature> features = const [],
      EdgeInsets padding = EdgeInsets.zero,
    }) async {
      tester.view
        ..physicalSize = _window
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: _window)
              .copyWith(displayFeatures: features),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: padding,
              child: FoldRow(
                start: const SizedBox.expand(key: _start),
                end: const SizedBox.expand(key: _end),
                gap: (width) => SizedBox(width: width),
                gapWidth: 24,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('splits evenly around the gap without a fold', (tester) async {
      await pump(tester);

      expect(tester.getRect(find.byKey(_start)).right, (951 - 24) / 2);
      expect(tester.getRect(find.byKey(_end)).left, (951 + 24) / 2);
    });

    testWidgets('ends each side at the fold', (tester) async {
      await pump(tester, features: [_bookFold]);

      expect(tester.getRect(find.byKey(_start)).right, 455.5);
      expect(tester.getRect(find.byKey(_end)).left, 495.5);
    });

    testWidgets('measures the fold from where the row starts', (tester) async {
      await pump(
        tester,
        features: [_bookFold],
        padding: const EdgeInsets.only(left: 24),
      );

      expect(tester.getRect(find.byKey(_start)).right, 455.5);
      expect(tester.getRect(find.byKey(_end)).left, 495.5);
    });

    testWidgets('keeps both sides when the device folds', (tester) async {
      await pump(tester);
      final start = tester.element(find.byKey(_start));

      await pump(tester, features: [_bookFold]);

      expect(tester.element(find.byKey(_start)), same(start));
    });
  });
}
