import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagly/config/analytics_service.dart';
import 'package:tagly/data/settings_repository.dart';

import '../helpers/fake_analytics_service.dart';
import '../helpers/fake_cache_manager.dart';
import '../helpers/fake_shared_preferences.dart';

void main() {
  group('settings repository', () {
    late SharedPreferences preferences;
    late CacheManager cacheManager;
    late SettingsRepository repository;
    late AnalyticsService analyticsService;

    setUp(() {
      preferences = FakeSharedPreferences();
      cacheManager = MockCacheManager();
      analyticsService = FakeAnalyticsService();
      repository = SettingsRepository(
        preferences: preferences,
        cacheManager: cacheManager,
        analyticsService: analyticsService,
      );
    });

    group('shouldAlwaysBroadcast', () {
      test('default is true', () {
        expect(repository.shouldAlwaysBroadcast, equals(true));
      });

      test('sets value correctly', () async {
        await repository.setShouldAlwaysBroadcast(false);

        expect(
          preferences.getBool(SettingsRepository.shouldAlwaysBroadcastKey),
          equals(false),
        );

        await repository.setShouldAlwaysBroadcast(true);

        expect(
          preferences.getBool(SettingsRepository.shouldAlwaysBroadcastKey),
          equals(true),
        );
      });
    });

    test('clears cache', () async {
      when(() => cacheManager.emptyCache()).thenAnswer((_) async {});

      await repository.clearCache();

      verify(() => cacheManager.emptyCache());
    });
  });
}
