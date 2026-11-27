import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsRepository extends ChangeNotifier {
  new({required this._cacheManager, required this.packageInfo});

  final CacheManager _cacheManager;
  final PackageInfo packageInfo;

  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}
