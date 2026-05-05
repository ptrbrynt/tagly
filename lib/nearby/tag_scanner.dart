import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tagly/nearby/ble_constants.dart';

class NearbyBroadcast {
  const NearbyBroadcast({
    required this.tagId,
    required this.deviceName,
    required this.rssi,
  });

  final int tagId;

  final String deviceName;

  /// Signal strength. Useful for "nearby" confidence
  final int rssi;
}

class TagScanner {
  StreamSubscription? _scanSubscription;
  final _broadcastController = StreamController<NearbyBroadcast?>.broadcast();

  /// Emits the currently detected broadcast, or null when none is visible.
  Stream<NearbyBroadcast?> get broadcastStream => _broadcastController.stream;

  Future<void> startScanning() async {
    await FlutterBluePlus.startScan(withServices: [Guid(kTaglyServiceUuid)]);

    _scanSubscription = FlutterBluePlus.onScanResults.listen(_handleResults);
  }

  void _handleResults(List<ScanResult> results) {
    if (results.isEmpty) {
      _broadcastController.add(null);
      return;
    }

    final best = results.reduce((a, b) => a.rssi > b.rssi ? a : b);

    final serviceDataMap = best.advertisementData.serviceData;
    final rawData = serviceDataMap[Guid(kTaglyServiceUuid)];
    if (rawData == null) return;

    final tagId = decodeTagId(Uint8List.fromList(rawData));
    if (tagId == null) return;

    _broadcastController.add(
      NearbyBroadcast(
        tagId: tagId,
        deviceName: switch (best.advertisementData.advName) {
          '' => 'Nearby singer',
          final value => value,
        },
        rssi: best.rssi,
      ),
    );
  }

  Future<void> stopScanning() async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    await FlutterBluePlus.stopScan();
    _broadcastController.add(null);
  }

  void dispose() {
    stopScanning();
    _broadcastController.close();
  }
}
