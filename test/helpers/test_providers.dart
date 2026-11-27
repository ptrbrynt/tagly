import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/config/providers.dart';
import 'package:tagly/data/fold_repository.dart';
import 'package:tagly/data/vertical_bar_repository.dart';

import 'fake_cache_manager.dart';
import 'fake_shared_preferences.dart';

Future<List<SingleChildWidget>> getTestProviders({
  required Database db,
  List<SingleChildWidget> overrides = const [],
}) async {
  return [
    Provider<CacheManager>(create: (_) => FakeCacheManager()),
    Provider<Dio>(create: (_) => Dio()),
    Provider<Database>.value(value: db),
    Provider<SharedPreferences>(create: (_) => FakeSharedPreferences()),
    ChangeNotifierProvider(
      create: (_) => FoldRepository(regionEvents: const Stream.empty()),
    ),
    ChangeNotifierProvider(
      create: (_) => VerticalBarRepository(events: const Stream.empty()),
    ),
    ...appProviders,
    ...overrides,
  ];
}
