// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository({
    required CacheManager cacheManager,
    required SharedPreferences preferences,
  }) : _cacheManager = cacheManager,
       _preferences = preferences;

  final SharedPreferences _preferences;
  final CacheManager _cacheManager;

  static const shouldAlwaysBroadcastKey = 'should_always_broadcast';

  bool get shouldAlwaysBroadcast =>
      _preferences.getBool(shouldAlwaysBroadcastKey) ?? false;

  Future<void> setShouldAlwaysBroadcast(bool shouldAlwaysBroadcast) async {
    await _preferences.setBool(
      shouldAlwaysBroadcastKey,
      shouldAlwaysBroadcast,
    );
  }

  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}
