import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoAlertDialog;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tagly/presentation/utils/fold_aware_dialogs.dart';

const _window = Size(951, 669);

const _bookFold = DisplayFeature(
  bounds: Rect.fromLTRB(455.5, 0, 495.5, 669),
  type: DisplayFeatureType.fold,
  state: DisplayFeatureState.postureHalfOpened,
);

void main() {
  group('fold-aware dialogs', () {
    Future<void> open(
      WidgetTester tester,
      Future<Object?> Function(BuildContext context) show, {
      List<DisplayFeature> features = const [],
      void Function(Object? result)? onResult,
    }) async {
      tester.view
        ..physicalSize = _window
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(displayFeatures: features),
            child: child!,
          ),
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async {
                    final result = await show(context);
                    onResult?.call(result);
                  },
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

    testWidgets('puts a confirmation on the trailing page of a book fold', (
      tester,
    ) async {
      await open(
        tester,
        (context) =>
            showConfirmDialog(context: context, title: 'Sure?', message: 'Yes'),
        features: [_bookFold],
      );

      final dialog = tester.getRect(find.byType(AlertDialog));
      expect(dialog.left, greaterThanOrEqualTo(_bookFold.bounds.right));
    });

    testWidgets('reports whether the user confirmed', (tester) async {
      Object? result;
      await open(
        tester,
        (context) => showConfirmDialog(
          context: context,
          title: 'Delete?',
          message: 'Gone for good',
          confirmLabel: 'Delete',
        ),
        onResult: (value) => result = value,
      );

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('returns the trimmed text from a prompt', (tester) async {
      Object? result;
      await open(
        tester,
        (context) => showTextPromptDialog(context: context, title: 'New List'),
        onResult: (value) => result = value,
      );

      await tester.enterText(find.byType(TextField), '  Warm-ups  ');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, 'Warm-ups');
    });

    testWidgets('treats an empty prompt as cancelled', (tester) async {
      Object? result = 'unset';
      await open(
        tester,
        (context) => showTextPromptDialog(context: context, title: 'New List'),
        onResult: (value) => result = value,
      );

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets('looks native on iOS', (tester) async {
      await open(
        tester,
        (context) =>
            showConfirmDialog(context: context, title: 'Sure?', message: 'Yes'),
      );

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
  });
}
