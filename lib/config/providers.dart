import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tagly/config/router.dart';
import 'package:tagly/data/barbershop_tags_api.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/nearby/nearby_notifier.dart';
import 'package:tagly/nearby/tag_broadcaster.dart';
import 'package:tagly/nearby/tag_scanner.dart';

List<SingleChildWidget> get productionProviders => [
  Provider(create: (context) => Dio()..interceptors.add(LogInterceptor())),
  Provider(create: (_) => TagBroadcaster()),
  Provider(create: (_) => TagScanner()),
  Provider<List<NavigatorObserver>>(create: (_) => [PosthogObserver()]),
  ...appProviders,
];

List<SingleChildWidget> get appProviders => [
  Provider(create: (context) => getRouter(context.read())),
  ChangeNotifierProvider(
    create: (context) {
      return NearbyNotifier(
        scanner: context.read(),
        broadcaster: context.read(),
      );
    },
  ),
  Provider(create: (context) => BarbershopTagsApi(dio: context.read())),
  ChangeNotifierProvider(
    create: (context) =>
        TagsRepository(db: context.read(), api: context.read()),
  ),
];
