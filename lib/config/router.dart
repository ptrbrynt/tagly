import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tagly/domain/tag_search_query.dart';
import 'package:tagly/presentation/adaptive/list_detail_shell.dart';
import 'package:tagly/presentation/adaptive/tagly_scaffold.dart';
import 'package:tagly/presentation/collections/tag_collection_screen.dart';
import 'package:tagly/presentation/favorites/favorites_screen.dart';
import 'package:tagly/presentation/lists/lists_screen.dart';
import 'package:tagly/presentation/lists/view_list_screen.dart';
import 'package:tagly/presentation/search/search_screen.dart';
import 'package:tagly/presentation/settings/settings_screen.dart';
import 'package:tagly/presentation/tag_details/tag_details_screen.dart';
import 'package:tagly/presentation/view_tag/view_tag_screen.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';

GoRouter getRouter(List<NavigatorObserver> observers) {
  final collectionKey = GlobalKey(debugLabel: 'collection');
  final favoritesKey = GlobalKey(debugLabel: 'favorites');
  final listKey = GlobalKey(debugLabel: 'list');

  Widget collection(BuildContext context, GoRouterState state) {
    return TagCollectionScreen(
      key: ValueKey(state.uri.queryParameters['title']),
      title: state.uri.queryParameters['title']!,
      initialQuery: TagSearchQuery.fromQueryParameters(
        state.uri.queryParametersAll,
      ),
      repository: context.read(),
      selectedTagId: _selectedTagId(state),
      onTagSelected: (id) => context.go(
        _withTag(state, path: '/collection/tag', id: id),
      ),
    );
  }

  Widget favorites(BuildContext context, GoRouterState state) {
    return FavoritesScreen(
      viewModel: context.watch(),
      selectedTagId: _selectedTagId(state),
      onTagSelected: (id) => context.go('/favorites/tag?id=$id'),
    );
  }

  Widget list(BuildContext context, GoRouterState state) {
    final id = int.parse(state.pathParameters['id']!);
    return ViewListScreen(
      key: ValueKey(id),
      listId: id,
      listName: state.uri.queryParameters['name']!,
      repository: context.read(),
      selectedTagId: _selectedTagId(state),
      onTagSelected: (tagId) => context.go(
        _withTag(state, path: '/lists/$id/tag', id: tagId),
      ),
    );
  }

  return GoRouter(
    observers: observers,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) {
          return SearchScreen(repository: context.watch());
        },
        routes: [
          _tagRoute(),
          _listDetailRoute(
            path: 'collection',
            listKey: collectionKey,
            list: collection,
            emptyDetailMessage: 'Select a tag',
          ),
          _listDetailRoute(
            path: 'favorites',
            listKey: favoritesKey,
            list: favorites,
            emptyDetailMessage: 'Select a favorite',
          ),
          GoRoute(
            path: 'lists',
            builder: (context, _) {
              return ListsScreen(viewModel: context.watch());
            },
            routes: [
              _listDetailRoute(
                path: ':id',
                listKey: listKey,
                list: list,
                emptyDetailMessage: 'Select a tag',
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
}

ShellRoute _listDetailRoute({
  required String path,
  required GlobalKey listKey,
  required Widget Function(BuildContext, GoRouterState) list,
  required String emptyDetailMessage,
}) {
  return ShellRoute(
    builder: (context, state, child) => ListDetailShell(
      listKey: listKey,
      list: list(context, state),
      detailNavigator: child,
    ),
    routes: [
      GoRoute(
        path: path,
        builder: (context, state) => ListDetailPage(
          listKey: listKey,
          list: list(context, state),
          emptyDetailMessage: emptyDetailMessage,
        ),
        routes: [_tagRoute(inDetailPane: true)],
      ),
    ],
  );
}

GoRoute _tagRoute({bool inDetailPane = false}) {
  Widget screen(BuildContext context, GoRouterState state) {
    final tagId = int.parse(state.uri.queryParameters['id']!);
    final viewTag = ViewTagScreen(
      key: ValueKey(tagId),
      tagId: tagId,
      tagsRepository: context.read(),
      cacheManager: context.read(),
      listsViewModel: context.read(),
      sharePlus: context.read(),
      onShowDetails: () => context.go(
        state.uri.replace(path: '${state.uri.path}/details').toString(),
      ),
    );
    return inDetailPane ? DetailPaneRoot(child: viewTag) : viewTag;
  }

  return GoRoute(
    path: 'tag',
    builder: inDetailPane ? null : screen,
    pageBuilder: inDetailPane
        ? (context, state) => DetailPanePage(
            key: state.pageKey,
            child: screen(context, state),
          )
        : null,
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
  );
}

int? _selectedTagId(GoRouterState state) =>
    state.uri.path.endsWith('/tag') || state.uri.path.contains('/tag/')
    ? int.tryParse(state.uri.queryParameters['id'] ?? '')
    : null;

String _withTag(GoRouterState state, {required String path, required int id}) {
  return Uri(
    path: path,
    queryParameters: {
      ...state.uri.queryParametersAll,
      'id': '$id',
    },
  ).toString();
}
