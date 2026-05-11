import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:recase/recase.dart';

class AnalyticsService {
  AnalyticsService._({required Posthog posthog}) : _posthog = posthog;

  final Posthog _posthog;

  static Future<AnalyticsService> setUp(Posthog posthog) async {
    final config =
        PostHogConfig('phc_vaeC2ix7HZjzBbHaLCtFy6LzYU98pQkWP8RnB3xxeRDp')
          ..host = 'https://eu.i.posthog.com'
          ..captureApplicationLifecycleEvents = true
          ..debug = kDebugMode
          ..optOut = true
          ..sessionReplay = true;
    config.errorTrackingConfig.captureFlutterErrors = kReleaseMode;
    config.errorTrackingConfig.capturePlatformDispatcherErrors = kReleaseMode;
    config.errorTrackingConfig.captureIsolateErrors = kReleaseMode;
    config.errorTrackingConfig.captureNativeExceptions = kReleaseMode;
    config.errorTrackingConfig.captureSilentFlutterErrors = false;

    await posthog.setup(config);

    return AnalyticsService._(posthog: posthog);
  }

  void capture({required String eventName, Map<String, Object>? properties}) {
    unawaited(
      _posthog.capture(
        eventName: eventName.snakeCase,
        properties: properties?.map((key, value) {
          return MapEntry(key.snakeCase, switch (value) {
            final String value => value.snakeCase,
            final Object value => value,
          });
        }),
      ),
    );
  }

  Future<bool> get isTrackingEnabled =>
      _posthog.isOptOut().then((isOptOut) => !isOptOut);

  Future<void> enableTracking() => _posthog.enable();

  Future<void> disableTracking() => _posthog.disable();
}
