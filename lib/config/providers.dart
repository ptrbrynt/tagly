import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tagly/data/barbershop_tags_api.dart';
import 'package:tagly/data/tags_repository.dart';

List<SingleChildWidget> get productionProviders => [
  Provider(create: (context) => Dio()..interceptors.add(LogInterceptor())),
  ...appProviders,
];

List<SingleChildWidget> get appProviders => [
  Provider(create: (context) => BarbershopTagsApi(dio: context.read())),
  ChangeNotifierProvider(
    create: (context) =>
        TagsRepository(db: context.read(), api: context.read()),
  ),
];
