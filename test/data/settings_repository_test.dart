import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagly/data/settings_repository.dart';

import '../helpers/fake_cache_manager.dart';
import '../helpers/fake_shared_preferences.dart';

void main() {
  group('settings repository', () {
    late SharedPreferences preferences;
    late CacheManager cacheManager;
    late SettingsRepository repository;

    setUp(() {
      preferences = FakeSharedPreferences();
      cacheManager = MockCacheManager();
      repository = SettingsRepository(
        preferences: preferences,
        cacheManager: cacheManager,
      );
    });

    group('shouldAlwaysBroadcast', () {
      test('default is false', () {
        expect(repository.shouldAlwaysBroadcast, equals(false));
      });

      test('sets value correctly', () async {
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
