import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tagly/config/router.dart';
import 'package:tagly/data/barbershop_tags_api.dart';
import 'package:tagly/data/lists_repository.dart';
import 'package:tagly/data/settings_repository.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/presentation/favorites/favorites_view_model.dart';
import 'package:tagly/presentation/lists/lists_view_model.dart';

List<SingleChildWidget> get productionProviders => [
  Provider(create: (context) => Dio()..interceptors.add(LogInterceptor())),
  Provider<List<NavigatorObserver>>(create: (_) => [PosthogObserver()]),
  Provider<CacheManager>(
    create: (_) => DefaultCacheManager(),
    dispose: (context, value) => value.dispose(),
  ),
  Provider<SharePlus>(create: (_) => SharePlus.instance),
  ...appProviders,
];

List<SingleChildWidget> get appProviders => [
  Provider(create: (context) => getRouter(context.read())),
  Provider(create: (context) => BarbershopTagsApi(dio: context.read())),
  ChangeNotifierProvider(
    create: (context) => TagsRepository(
      db: context.read(),
      api: context.read(),
      cacheManager: context.read(),
    ),
  ),
  Provider(
    create: (context) => ListsRepository(db: context.read()),
  ),
  ChangeNotifierProvider(
    create: (context) => SettingsRepository(
      preferences: context.read(),
      cacheManager: context.read(),
      analyticsService: context.read(),
      packageInfo: context.read(),
    ),
  ),

  ChangeNotifierProvider(
    create: (context) => FavoritesViewModel(repository: context.read()),
  ),
  ChangeNotifierProvider(
    create: (context) => ListsViewModel(repository: context.read()),
  ),
];
