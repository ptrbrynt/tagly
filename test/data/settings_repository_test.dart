import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagly/data/settings_repository.dart';

import '../helpers/fake_shared_preferences.dart';

void main() {
  group('settings repository', () {
    late SharedPreferences preferences;
    late SettingsRepository repository;

    setUp(() {
      preferences = FakeSharedPreferences();
      repository = SettingsRepository(preferences: preferences);
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
  });
}
