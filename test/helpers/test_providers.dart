import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/config/analytics_service.dart';
import 'package:tagly/config/providers.dart';
import 'package:tagly/nearby/tag_broadcaster.dart';
import 'package:tagly/nearby/tag_scanner.dart';

import '../fakes/fake_tag_broadcaster.dart';
import '../fakes/fake_tag_scanner.dart';
import 'fake_analytics_service.dart';
import 'test_db.dart';

Future<List<SingleChildWidget>> getTestProviders({
  List<SingleChildWidget> overrides = const [],
}) async {
  final db = await openTestDb();
  return [
    Provider<Dio>(create: (_) => Dio()),
    Provider<AnalyticsService>(create: (_) => FakeAnalyticsService()),
    Provider<Database>.value(value: db),
    Provider<TagBroadcaster>(create: (_) => FakeTagBroadcaster()),
    Provider<TagScanner>(create: (_) => FakeTagScanner()),
    Provider<List<NavigatorObserver>>.value(value: []),
    ...appProviders,
    ...overrides,
  ];
}
