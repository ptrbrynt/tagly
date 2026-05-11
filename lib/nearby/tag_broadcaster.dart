import 'dart:async';

import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:tagly/nearby/ble_constants.dart';

class TagBroadcaster {
  final _peripheral = FlutterBlePeripheral();
  bool _isAdvertising = false;
  bool get isAdvertising => _isAdvertising;

  Future<bool> isSupported() => _peripheral.isSupported;

  Future<void> startBroadcast(int tagId) async {
    if (_isAdvertising) await stopBroadcast();

    final data = AdvertiseData(
      serviceUuid: kTaglyServiceUuid,
      serviceData: encodeTagId(tagId),
      localName: 'Tagly',
    );

    final settings = AdvertiseSettings(
      advertiseMode: .advertiseModeBalanced,
      txPowerLevel: .advertiseTxPowerMedium,
      timeout: 0,
    );

    await _peripheral.start(advertiseData: data, advertiseSettings: settings);
    _isAdvertising = true;
  }

  Future<void> stopBroadcast() async {
    await _peripheral.stop();
    _isAdvertising = false;
  }
}
