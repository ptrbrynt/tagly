import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tagly/nearby/nearby_notifier.dart';
import 'package:tagly/nearby/tag_scanner.dart';
import 'package:tagly/presentation/search/search_screen.dart';

import '../../fakes/fake_tag_broadcaster.dart';
import '../../fakes/fake_tag_scanner.dart';
import '../../helpers/test_app.dart';
import '../../helpers/test_providers.dart';

void main() {
  group('search screen', () {
    late FakeTagScanner scanner;
    late FakeTagBroadcaster broadcaster;
    late NearbyNotifier nearbyNotifier;
    late List<SingleChildWidget> providers;

    setUp(() async {
      scanner = FakeTagScanner();
      broadcaster = FakeTagBroadcaster();
      nearbyNotifier = NearbyNotifier(
        broadcaster: broadcaster,
        scanner: scanner,
      );

      await nearbyNotifier.init();
      providers = [
        ...(await getTestProviders()),
        ChangeNotifierProvider.value(value: nearbyNotifier),
      ];
    });

    tearDown(() async {
      nearbyNotifier.dispose();
    });

    testWidgets('shows MaterialBanner when broadcast detected', (tester) async {
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

      scanner.simulateBroadcast(
        const NearbyBroadcast(tagId: 42, deviceName: 'Pete', rssi: -60),
      );
      await tester.pump();

      expect(find.text('Pete is sharing a tag'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
    });
  });
}
