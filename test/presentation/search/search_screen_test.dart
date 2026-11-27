import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/domain/vertical_bar.dart';
import 'package:tagly/presentation/search/search_screen.dart';
import 'package:tagly/presentation/utils/vertical_bar_controls.dart';

import '../../helpers/test_app.dart';
import '../../helpers/test_db.dart';
import '../../helpers/test_providers.dart';

void main() {
  group('search screen', () {
    late Database db;
    late List<SingleChildWidget> providers;

    setUpAll(() async {
      db = await openTestDb();
      await seedTestDb(db);

      providers = await getTestProviders(db: db);
    });

    tearDownAll(() async {
      await db.close();
    });

    testWidgets('searching for a tag by query displays results', (
      tester,
    ) async {
      await pumpSearchScreen(tester, providers);

      await tester.pumpAndSettle();

      await tester.tap(find.byType(SearchBar));

      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await tester.enterText(find.byType(SearchBar).last, 'i hear you sing');
        await tester.sendKeyEvent(.enter);
      });

      await tester.pumpAndSettle();
      await _pumpUntilFound(tester, find.text("'Til I Hear You Sing"));

      expect(find.text("'Til I Hear You Sing"), findsWidgets);
      expect(find.text('#4696'), findsOne);
    });

    testWidgets('keeps the search view buttons as the vertical bar goes', (
      tester,
    ) async {
      // The closed display held upright, then unfolded and held upright,
      // where the system shows no vertical bar.
      tester.view
        ..physicalSize = const Size(466, 678)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final bar = ValueNotifier<VerticalBar?>(
        const VerticalBar(
          edge: VerticalBarEdge.right,
          controls: ScreenRect(left: 394, top: 172, width: 48, height: 450),
        ),
      );
      addTearDown(bar.dispose);
      await pumpSearchScreen(tester, providers, verticalBar: bar);
      await tester.tap(find.byType(SearchBar));
      await tester.pumpAndSettle();
      final back = find.byType(BackButton);
      final filter = find.byIcon(Icons.filter_list_rounded);
      final help = find.byIcon(Icons.help_outline_rounded);
      for (final control in [back, filter, help]) {
        expect(control, findsOneWidget);
        expect(tester.getCenter(control).dx, 418);
      }

      bar.value = null;
      await tester.pumpAndSettle();
      final field = tester.getCenter(find.byType(TextField).last).dy;
      for (final control in [back, filter, help]) {
        expect(control, findsOneWidget);
        expect(tester.getCenter(control).dy, moreOrLessEquals(field));
      }

      await tester.tap(back);
      await tester.pumpAndSettle();
      expect(back, findsNothing);
    });

    testWidgets('places collections beside browse when wide', (tester) async {
      tester.view
        ..physicalSize = const Size(951, 669)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pumpSearchScreen(tester, providers);
      await tester.pump();

      final favorites = tester.getTopLeft(find.text('Favorites'));
      final popular = tester.getTopLeft(find.text('Popular Tags'));
      expect(popular.dy, favorites.dy);
      expect(popular.dx, greaterThan(favorites.dx));
    });

    testWidgets('stacks browse below collections when upright', (tester) async {
      tester.view
        ..physicalSize = const Size(669, 951)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pumpSearchScreen(tester, providers);
      await tester.pump();

      final favorites = tester.getTopLeft(find.text('Favorites'));
      final popular = tester.getTopLeft(find.text('Popular Tags'));
      expect(popular.dy, greaterThan(favorites.dy));
      expect(popular.dx, favorites.dx);
    });

    testWidgets('stacks browse below collections when narrow', (tester) async {
      tester.view
        ..physicalSize = const Size(466, 900)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pumpSearchScreen(tester, providers);
      await tester.pump();

      final favorites = tester.getTopLeft(find.text('Favorites'));
      final popular = tester.getTopLeft(find.text('Popular Tags'));
      expect(popular.dy, greaterThan(favorites.dy));
      expect(popular.dx, favorites.dx);
    });
  });
}

Future<void> pumpSearchScreen(
  WidgetTester tester,
  List<SingleChildWidget> providers, {
  ValueListenable<VerticalBar?>? verticalBar,
}) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: providers,
      child: ValueListenableBuilder<VerticalBar?>(
        valueListenable: verticalBar ?? ValueNotifier<VerticalBar?>(null),
        builder: (context, bar, _) => VerticalBarScope(
          verticalBar: bar,
          child: TestApp(
            child: SearchScreen(
              repository: context.read(),
              onTagSelected: (_) {},
              onSearchResultSelected: (_, _) {},
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final stopwatch = Stopwatch()..start();
  while (finder.evaluate().isEmpty && stopwatch.elapsed < timeout) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
}
