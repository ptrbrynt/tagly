import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSharedPreferences extends Fake implements SharedPreferences {
  final _prefs = <String, dynamic>{};
  @override
  Future<bool> clear() async {
    _prefs.clear();
    return true;
  }

  @override
  Future<bool> commit() async {
    return true;
  }

  @override
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  @override
  Object? get(String key) {
    return _prefs.containsKey(key) ? _prefs[key] : null;
  }

  @override
  bool? getBool(String key) {
    return get(key) as bool?;
  }

  @override
  double? getDouble(String key) {
    return get(key) as double?;
  }

  @override
  int? getInt(String key) {
    return get(key) as int?;
  }

  @override
  Set<String> getKeys() {
    return Set.of(_prefs.keys);
  }

  @override
  String? getString(String key) {
    return get(key) as String?;
  }

  @override
  List<String>? getStringList(String key) {
    return get(key) as List<String>?;
  }

  @override
  Future<void> reload() async {}

  @override
  Future<bool> remove(String key) async {
    _prefs.remove(key);
    return true;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _prefs[key] = value;
    return true;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _prefs[key] = value;
    return true;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _prefs[key] = value;
    return true;
  }

  @override
  Future<bool> setString(String key, String value) async {
    _prefs[key] = value;
    return true;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _prefs[key] = value;
    return true;
  }
}
