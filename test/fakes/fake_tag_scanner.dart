// test/fakes/fake_tag_scanner.dart
import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:tagly/nearby/tag_scanner.dart';

class FakeTagScanner extends Fake implements TagScanner {
  final _controller = StreamController<NearbyBroadcast?>.broadcast();

  @override
  Stream<NearbyBroadcast?> get broadcastStream => _controller.stream;

  @override
  Future<void> startScanning() async {}

  @override
  Future<void> stopScanning() async {
    _controller.add(null);
  }

  @override
  void dispose() => _controller.close();

  void simulateBroadcast(NearbyBroadcast broadcast) {
    _controller.add(broadcast);
  }

  void simulateBroadcastLost() {
    _controller.add(null);
  }
}
