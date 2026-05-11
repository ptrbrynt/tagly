import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tagly/nearby/tag_broadcaster.dart';
import 'package:tagly/nearby/tag_scanner.dart';

class NearbyNotifier extends ChangeNotifier {
  NearbyNotifier({
    required TagBroadcaster broadcaster,
    required TagScanner scanner,
  }) : _broadcaster = broadcaster,
       _scanner = scanner {
    unawaited(init());
  }

  final TagBroadcaster _broadcaster;
  final TagScanner _scanner;

  NearbyBroadcast? _detectedBroadcast;
  bool _isBroadcasting = false;

  NearbyBroadcast? get detectedBroadcast => _detectedBroadcast;
  bool get isBroadcasting => _isBroadcasting;

  Future<void> init() async {
    _scanner.broadcastStream.listen((broadcast) {
      // Don't surface our own broadcast back to us.
      if (_isBroadcasting) return;
      _detectedBroadcast = broadcast;
      notifyListeners();
    });
    await _scanner.startScanning();
  }

  Future<void> startBroadcasting(int tagId) async {
    await _broadcaster.startBroadcast(tagId);
    _isBroadcasting = true;
    notifyListeners();
  }

  Future<void> stopBroadcasting() async {
    await _broadcaster.stopBroadcast();
    _isBroadcasting = false;
    notifyListeners();
  }

  void dismissDetectedBroadcast() {
    _detectedBroadcast = null;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_broadcaster.stopBroadcast());
    unawaited(_scanner.dispose());
    super.dispose();
  }
}
