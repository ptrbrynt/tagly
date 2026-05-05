import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tagly/config/providers.dart';
import 'package:tagly/config/router.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/db/database.dart';
import 'package:tagly/domain/result.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await openTaglyDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: db),
        ...productionProviders,
      ],
      child: MainApp(),
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
      _onResume();
    }
  }

  Future<void> _onResume() async {
    final result = await context.read<TagsRepository>().syncTags();

    if (!mounted) return;
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
    return MaterialApp.router(routerConfig: router);
  }
}
