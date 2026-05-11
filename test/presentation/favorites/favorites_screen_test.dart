import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/presentation/favorites/favorites_screen.dart';
import 'package:tagly/presentation/search/search_screen.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';

import '../../helpers/test_app.dart';
import '../../helpers/test_db.dart';
import '../../helpers/test_providers.dart';

void main() {
  group('favorites screen', () {
    late Database db;
    late List<SingleChildWidget> providers;

    setUp(() async {
      db = await openTestDb();
      await seedTestDb(db);
      providers = await getTestProviders(db: db);
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets('shows loading indicator while favorites are loading', (
      tester,
    ) async {
      await pumpFavoritesScreen(tester, providers);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Let the async load complete so the VM is not disposed mid-flight.
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();
    });

    testWidgets('shows app bar with Favorites title', (tester) async {
      await pumpFavoritesScreen(tester, providers);
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();

      expect(find.text('Favorites'), findsOneWidget);
    });

    testWidgets('shows empty list when there are no favorites', (tester) async {
      await pumpFavoritesScreen(tester, providers);
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(EmptyStateCard), findsOneWidget);
      expect(find.byType(TagListTile), findsNothing);
    });

    testWidgets('shows a tile for each favorite tag', (tester) async {
      await tester.runAsync(() async {
        await db.update(
          'tags',
          {'is_favorite': 1},
          where: 'id IN (?, ?)',
          whereArgs: [1482, 4696],
        );
      });

      await pumpFavoritesScreen(tester, providers);
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();

      expect(find.text("'Less You Listen"), findsOneWidget);
      expect(find.text('#1482'), findsOneWidget);
      expect(find.text("'Til I Hear You Sing"), findsOneWidget);
      expect(find.text('#4696'), findsOneWidget);
    });

    testWidgets('does not show non-favorite tags', (tester) async {
      await tester.runAsync(() async {
        await db.update(
          'tags',
          {'is_favorite': 1},
          where: 'id = ?',
          whereArgs: [1482],
        );
      });

      await pumpFavoritesScreen(tester, providers);
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();

      expect(find.text("'Less You Listen"), findsOneWidget);
      expect(find.text('#1482'), findsOneWidget);
      expect(find.text("'Til I Hear You Sing"), findsNothing);
    });
  });
}

Future<void> pumpFavoritesScreen(
  WidgetTester tester,
  List<SingleChildWidget> providers,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: providers,
      child: Builder(
        builder: (context) =>
            TestApp(child: FavoritesScreen(viewModel: context.read())),
      ),
    ),
  );
}
