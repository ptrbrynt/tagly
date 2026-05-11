// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagly/config/analytics_service.dart';

class SettingsRepository extends ChangeNotifier {
  SettingsRepository({
    required AnalyticsService analyticsService,
    required CacheManager cacheManager,
    required SharedPreferences preferences,
  }) : _analyticsService = analyticsService,
       _cacheManager = cacheManager,
       _preferences = preferences;

  final SharedPreferences _preferences;
  final CacheManager _cacheManager;
  final AnalyticsService _analyticsService;

  static const shouldAlwaysBroadcastKey = 'should_always_broadcast';

  bool get shouldAlwaysBroadcast =>
      _preferences.getBool(shouldAlwaysBroadcastKey) ?? true;

  Future<void> setShouldAlwaysBroadcast(bool shouldAlwaysBroadcast) async {
    await _preferences.setBool(
      shouldAlwaysBroadcastKey,
      shouldAlwaysBroadcast,
    );
    notifyListeners();
  }

  Future<bool> get isAnalyticsEnabled => _analyticsService.isTrackingEnabled;

  Future<void> enableAnalytics() => _analyticsService.enableTracking();

  Future<void> disableAnalytics() => _analyticsService.disableTracking();

  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}
