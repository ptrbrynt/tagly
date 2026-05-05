import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/nearby/nearby_notifier.dart';
import 'package:tagly/nearby/tag_scanner.dart';

import '../fakes/fake_tag_broadcaster.dart';
import '../fakes/fake_tag_scanner.dart';

void main() {
  late FakeTagBroadcaster broadcaster;
  late FakeTagScanner scanner;
  late NearbyNotifier notifier;

  setUp(() {
    broadcaster = FakeTagBroadcaster();
    scanner = FakeTagScanner();
    notifier = NearbyNotifier(broadcaster: broadcaster, scanner: scanner);
  });

  tearDown(() => notifier.dispose());

  test('does not surface own broadcast as detected', () async {
    await notifier.init();
    await notifier.startBroadcasting(42);

    // Even if the scanner fires while we're broadcasting,
    // detectedBroadcast should remain null.
    scanner.simulateBroadcast(
      NearbyBroadcast(tagId: 42, deviceName: 'Self', rssi: -50),
    );

    await Future.delayed(Duration(milliseconds: 10));

    expect(notifier.detectedBroadcast, isNull);
  });

  test('surfaces detected broadcast when not broadcasting', () async {
    await notifier.init();
    scanner.simulateBroadcast(
      NearbyBroadcast(tagId: 99, deviceName: 'Pete', rssi: -65),
    );

    await Future.delayed(Duration(milliseconds: 10));

    expect(notifier.detectedBroadcast?.tagId, 99);
  });

  test('clears broadcast on dismiss', () async {
    await notifier.init();
    scanner.simulateBroadcast(
      NearbyBroadcast(tagId: 99, deviceName: 'Pete', rssi: -65),
    );
    await Future.delayed(Duration(milliseconds: 10));
    notifier.dismissDetectedBroadcast();
    await Future.delayed(Duration(milliseconds: 10));
    expect(notifier.detectedBroadcast, isNull);
  });
}
