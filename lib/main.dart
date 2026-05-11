import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagly/config/analytics_service.dart';
import 'package:tagly/config/providers.dart';
import 'package:tagly/config/theme.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/db/database.dart';
import 'package:tagly/db/legacy/legacy_db.dart';
import 'package:tagly/db/legacy/legacy_migration_repository.dart';
import 'package:tagly/domain/result.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final analyticsService = await AnalyticsService.setUp(Posthog());

  final db = await openTaglyDatabase(singleInstance: false);

  final legacyDb = await openLegacyDatabase(singleInstance: false);

  final migrationRepo = LegacyMigrationRepository(
    legacyDatabase: legacyDb,
    newDatabase: db,
  );

  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: analyticsService),
        Provider.value(value: db),
        Provider.value(value: sharedPrefs),
        Provider.value(value: migrationRepo),
        ...productionProviders,
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onResume: _onResume);
    if (SchedulerBinding.instance.lifecycleState == .resumed) {
      unawaited(_onResume());
    }
  }

  Future<void> _onResume() async {
    final result = await context.read<TagsRepository>().syncTags();

    if (!mounted) return;

    await context.read<LegacyMigrationRepository>().migrate();

    final message = switch (result) {
      Ok() => 'Tags synced successfully',
      Failure(:final message) => message,
    };
    debugPrint(message);
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: context.watch<GoRouter>(),
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
