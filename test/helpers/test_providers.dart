import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/config/analytics_service.dart';
import 'package:tagly/config/providers.dart';
import 'package:tagly/nearby/tag_broadcaster.dart';
import 'package:tagly/nearby/tag_scanner.dart';

import '../fakes/fake_tag_broadcaster.dart';
import '../fakes/fake_tag_scanner.dart';
import 'fake_analytics_service.dart';
import 'fake_cache_manager.dart';
import 'fake_shared_preferences.dart';
import 'test_db.dart';

Future<List<SingleChildWidget>> getTestProviders({
  Database? db,
  List<SingleChildWidget> overrides = const [],
}) async {
  db ??= await openTestDb();
  return [
    Provider<CacheManager>(create: (_) => FakeCacheManager()),
    Provider<Dio>(create: (_) => Dio()),
    Provider<AnalyticsService>(create: (_) => FakeAnalyticsService()),
    Provider<Database>.value(value: db),
    Provider<TagBroadcaster>(create: (_) => FakeTagBroadcaster()),
    Provider<TagScanner>(create: (_) => FakeTagScanner()),
    Provider<List<NavigatorObserver>>.value(value: const []),
    Provider<SharedPreferences>(create: (_) => FakeSharedPreferences()),
    ...appProviders,
    ...overrides,
  ];
}
