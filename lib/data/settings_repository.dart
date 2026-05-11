// ignore_for_file: avoid_positional_boolean_parameters

import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  static const shouldAlwaysBroadcastKey = 'should_always_broadcast';

  bool get shouldAlwaysBroadcast =>
      _preferences.getBool(shouldAlwaysBroadcastKey) ?? false;

  Future<void> setShouldAlwaysBroadcast(bool shouldAlwaysBroadcast) async {
    await _preferences.setBool(
      shouldAlwaysBroadcastKey,
      shouldAlwaysBroadcast,
    );
  }
}
