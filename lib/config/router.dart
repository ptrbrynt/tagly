import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tagly/domain/tag_search_query.dart';
import 'package:tagly/presentation/collections/tag_collection_screen.dart';
import 'package:tagly/presentation/favorites/favorites_screen.dart';
import 'package:tagly/presentation/lists/lists_screen.dart';
import 'package:tagly/presentation/lists/view_list_screen.dart';
import 'package:tagly/presentation/lists/view_list_view_model.dart';
import 'package:tagly/presentation/search/search_screen.dart';
import 'package:tagly/presentation/settings/settings_screen.dart';
import 'package:tagly/presentation/tag_details/tag_details_screen.dart';
import 'package:tagly/presentation/view_tag/view_tag_screen.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';

GoRouter getRouter(List<NavigatorObserver> observers) => GoRouter(
  observers: observers,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, _) {
        return SearchScreen(repository: context.watch());
      },
      routes: [
        GoRoute(
          path: 'tag',
          builder: (context, state) {
            final tagId = state.uri.queryParameters['id']!;
            return ViewTagScreen(
              tagId: int.parse(tagId),
              tagsRepository: context.read(),
              cacheManager: context.read(),
              listsRepository: context.read(),
              settingsRepository: context.read(),
              sharePlus: context.read(),
            );
          },
          routes: [
            GoRoute(
              path: 'details',
              builder: (context, state) {
                final tagId = state.uri.queryParameters['id']!;
                return TagDetailsScreen(
                  viewModel: ViewTagViewModel(
                    repository: context.read(),
                    tagId: int.parse(tagId),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'collection',
          builder: (context, state) {
            final title = state.uri.queryParameters['title']!;
            return TagCollectionScreen(
              title: title,
              initialQuery: TagSearchQuery.fromQueryParameters(
                state.uri.queryParametersAll,
              ),
              repository: context.read(),
            );
          },
        ),
        GoRoute(
          path: 'favorites',
          builder: (context, _) {
            return FavoritesScreen(viewModel: context.watch());
          },
        ),
        GoRoute(
          path: 'lists',
          builder: (context, _) {
            return ListsScreen(viewModel: context.watch());
          },
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                final name = state.uri.queryParameters['name']!;
                return ViewListScreen(
                  listName: name,
                  viewModel: ViewListViewModel(
                    listId: id,
                    repository: context.read(),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, _) {
            return SettingsScreen(
              settingsRepository: context.read(),
              tagsRepository: context.read(),
            );
          },
        ),
      ],
    ),
  ],
);
