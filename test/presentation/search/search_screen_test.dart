import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/presentation/search/search_screen.dart';

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
  List<SingleChildWidget> providers,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: providers,
      child: Builder(
        builder: (context) {
          return TestApp(child: SearchScreen(repository: context.read()));
        },
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
