import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tagly/config/analytics_service.dart';

class SettingsRepository extends ChangeNotifier {
  SettingsRepository({
    required AnalyticsService analyticsService,
    required CacheManager cacheManager,
    required this.packageInfo,
  }) : _analyticsService = analyticsService,
       _cacheManager = cacheManager;

  final CacheManager _cacheManager;
  final AnalyticsService _analyticsService;
  final PackageInfo packageInfo;

  Future<bool> get isAnalyticsEnabled => _analyticsService.isTrackingEnabled;

  Future<void> enableAnalytics() => _analyticsService.enableTracking();

  Future<void> disableAnalytics() => _analyticsService.disableTracking();

  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}
