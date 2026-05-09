import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/nearby/nearby_notifier.dart';
import 'package:tagly/nearby/tag_scanner.dart';
import 'package:tagly/presentation/search/search_screen.dart';

import '../../fakes/fake_tag_broadcaster.dart';
import '../../fakes/fake_tag_scanner.dart';
import '../../helpers/test_app.dart';
import '../../helpers/test_db.dart';
import '../../helpers/test_providers.dart';

void main() {
  group('search screen', () {
    late Database db;
    late FakeTagScanner scanner;
    late FakeTagBroadcaster broadcaster;
    late NearbyNotifier nearbyNotifier;
    late List<SingleChildWidget> providers;

    setUp(() async {
      db = await openTestDb();
      await seedTestDb(db);

      scanner = FakeTagScanner();
      broadcaster = FakeTagBroadcaster();
      nearbyNotifier = NearbyNotifier(
        broadcaster: broadcaster,
        scanner: scanner,
      );

      await nearbyNotifier.init();
      providers = [
        ...(await getTestProviders(db: db)),
        ChangeNotifierProvider.value(value: nearbyNotifier),
      ];
    });

    tearDown(() async {
      await db.close();
      nearbyNotifier.dispose();
    });

    testWidgets('shows MaterialBanner when broadcast detected', (tester) async {
      await pumpSearchScreen(tester, providers);

      scanner.simulateBroadcast(
        const NearbyBroadcast(tagId: 42, deviceName: 'Pete', rssi: -60),
      );
      await tester.pump();

      expect(find.text('Pete is sharing a tag'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
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
      });

      await tester.pumpAndSettle();

      expect(find.text("'Til I Hear You Sing"), findsWidgets);
      expect(find.text('#4696'), findsOne);
    });

    testWidgets('searching for a tag by ID displays result', (tester) async {
      await pumpSearchScreen(tester, providers);

      await tester.pumpAndSettle();

      await tester.tap(find.byType(SearchBar));

      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await tester.enterText(find.byType(SearchBar).last, '4696');
      });

      await tester.pumpAndSettle();

      expect(find.text("'Til I Hear You Sing"), findsOne);
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
              nearby: context.read(),
            ),
          );
        },
      ),
    ),
  );
}
