import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tagly/domain/device_regions.dart';

class DeviceRegionsRepository extends ChangeNotifier {
  new({required Stream<Object?> events}) {
    _subscription = events.listen(
      _onEvent,
      // Platforms without the native bridge have nothing to report.
      onError: (Object _) {},
      cancelOnError: true,
    );
  }

  factory platform() => DeviceRegionsRepository(
    events: const EventChannel('com.ptrbrynt.tagly/device_regions')
        .receiveBroadcastStream(),
  );

  late final StreamSubscription<Object?> _subscription;

  DeviceRegions _regions = const DeviceRegions();
  DeviceRegions get regions => _regions;

  void _onEvent(Object? event) {
    if (event is! Map) return;
    final json = jsonDecode(jsonEncode(event)) as Map<String, dynamic>;
    final next = DeviceRegions.fromJson(json);
    if (next == _regions) return;
    _regions = next;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
