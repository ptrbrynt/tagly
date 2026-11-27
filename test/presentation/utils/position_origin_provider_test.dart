import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tagly/presentation/utils/position_origin_provider.dart';

void main() {
  group('PositionOriginProvider', () {
    testWidgets('resolves the origin of its child when called', (tester) async {
      Rect? Function()? resolveOrigin;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: PositionOriginProvider(
              builder: (context, origin) {
                resolveOrigin = origin;
                return const SizedBox(key: Key('child'), width: 40, height: 20);
              },
            ),
          ),
        ),
      );

      expect(resolveOrigin!(), tester.getRect(find.byKey(const Key('child'))));
    });

    testWidgets('rebuilds without throwing when moved under a new transition', (
      tester,
    ) async {
      final wrapped = ValueNotifier(false);
      addTearDown(wrapped.dispose);
      final subtreeKey = GlobalKey();

      final provider = PositionOriginProvider(
        key: subtreeKey,
        builder: (context, _) => Icon(
          Icons.more_vert_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: ValueListenableBuilder(
              valueListenable: wrapped,
              builder: (context, isWrapped, _) => isWrapped
                  ? FractionalTranslation(
                      translation: const Offset(0.25, 0),
                      child: provider,
                    )
                  : provider,
            ),
          ),
        ),
      );

      wrapped.value = true;
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
