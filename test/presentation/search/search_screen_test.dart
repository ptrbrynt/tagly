import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

      expect(find.text("'Til I Hear You Sing"), findsWidgets);
      expect(find.text('#4696'), findsOne);
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
          return TestApp(
            child: SearchScreen(
              repository: context.read(),
            ),
          );
        },
      ),
    ),
  );
}
