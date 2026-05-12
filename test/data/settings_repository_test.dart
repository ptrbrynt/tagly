import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tagly/config/analytics_service.dart';
import 'package:tagly/data/settings_repository.dart';

import '../fakes/fake_package_info.dart';
import '../helpers/fake_analytics_service.dart';
import '../helpers/fake_cache_manager.dart';

void main() {
  group('settings repository', () {
    late CacheManager cacheManager;
    late SettingsRepository repository;
    late AnalyticsService analyticsService;

    setUp(() {
      cacheManager = MockCacheManager();
      analyticsService = FakeAnalyticsService();
      repository = SettingsRepository(
        cacheManager: cacheManager,
        analyticsService: analyticsService,
        packageInfo: fakePackageInfo,
      );
    });

    test('clears cache', () async {
      when(() => cacheManager.emptyCache()).thenAnswer((_) async {});

      await repository.clearCache();

      verify(() => cacheManager.emptyCache());
    });
  });
}
