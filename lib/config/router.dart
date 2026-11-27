import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tagly/domain/tag_search_query.dart';
import 'package:tagly/presentation/collections/tag_collection_screen.dart';
import 'package:tagly/presentation/collections/tag_collection_view_model.dart';
import 'package:tagly/presentation/favorites/favorites_screen.dart';
import 'package:tagly/presentation/lists/lists_screen.dart';
import 'package:tagly/presentation/lists/view_list_screen.dart';
import 'package:tagly/presentation/lists/view_list_view_model.dart';
import 'package:tagly/presentation/search/search_screen.dart';
import 'package:tagly/presentation/settings/settings_screen.dart';
import 'package:tagly/presentation/tag_details/tag_details_screen.dart';
import 'package:tagly/presentation/utils/list_detail_layout.dart';
import 'package:tagly/presentation/view_tag/view_tag_screen.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';

typedef NavigatorObserversFactory = List<NavigatorObserver> Function();

// Each list of tags is a ShellRoute so the selected tag lives in the shell's
// navigator. On wide windows the shell shows the list beside that navigator;
// on narrow ones the list is the navigator's first page. The navigator keeps
// its state when the device opens or closes, so the open tag (and its audio)
// survives the switch.
GoRouter getRouter(NavigatorObserversFactory observers) => GoRouter(
  observers: observers(),
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
            final tagId = int.parse(state.uri.queryParameters['id']!);
            return _viewTagScreen(
              context,
              tagId,
              onShowDetails: () => context.go('/tag/details?id=$tagId'),
            );
          },
          routes: [
            GoRoute(
              path: 'details',
              builder: (context, state) => _tagDetailsScreen(
                int.parse(state.uri.queryParameters['id']!),
              ),
            ),
          ],
        ),
        ShellRoute(
          observers: observers(),
          builder: (context, state, child) {
            return ChangeNotifierProvider(
              key: ValueKey(state.uri.query),
              create: (_) => TagCollectionViewModel(
                initialQuery: TagSearchQuery.fromQueryParameters(
                  state.uri.queryParametersAll,
                ),
                repository: context.read(),
              ),
              child: Builder(
                builder: (context) => ListDetailLayout(
                  list: _collectionScreen(context, state),
                  detail: child,
                  onBack: () => context.go('/'),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              path: 'collection',
              builder: (context, state) => fitsTwoPanes(context)
                  ? const NoTagSelected()
                  : ListPane(child: _collectionScreen(context, state)),
              routes: [_tagInListRoute()],
            ),
          ],
        ),
        ShellRoute(
          observers: observers(),
          builder: (context, state, child) => ListDetailLayout(
            list: _favoritesScreen(context, state),
            detail: child,
            onBack: () => context.go('/'),
          ),
          routes: [
            GoRoute(
              path: 'favorites',
              builder: (context, state) => fitsTwoPanes(context)
                  ? const NoTagSelected()
                  : ListPane(child: _favoritesScreen(context, state)),
              routes: [_tagInListRoute()],
            ),
          ],
        ),
        GoRoute(
          path: 'lists',
          builder: (context, _) {
            return ListsScreen(viewModel: context.watch());
          },
          routes: [
            ShellRoute(
              observers: observers(),
              builder: (context, state, child) {
                final listId = int.parse(state.pathParameters['id']!);
                return ChangeNotifierProvider(
                  key: ValueKey(listId),
                  create: (_) => ViewListViewModel(
                    listId: listId,
                    repository: context.read(),
                  ),
                  child: Builder(
                    builder: (context) => ListDetailLayout(
                      list: _viewListScreen(context, state),
                      detail: child,
                      onBack: () => context.go('/lists'),
                    ),
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) => fitsTwoPanes(context)
                      ? const NoTagSelected()
                      : ListPane(child: _viewListScreen(context, state)),
                  routes: [_tagInListRoute()],
                ),
              ],
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

GoRoute _tagInListRoute() => GoRoute(
  path: 'tags/:tagId',
  // Named like the top-level tag route so analytics report one screen name.
  pageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    name: 'tag',
    restorationId: state.pageKey.value,
    child: _viewTagScreen(
      context,
      _selectedTagId(state)!,
      showsBackButton: !fitsTwoPanes(context),
      onShowDetails: () =>
          context.go(_withQuery('${state.matchedLocation}/details', state)),
    ),
  ),
  routes: [
    GoRoute(
      path: 'details',
      builder: (context, state) => _tagDetailsScreen(_selectedTagId(state)!),
    ),
  ],
);

Widget _collectionScreen(BuildContext context, GoRouterState state) {
  return TagCollectionScreen(
    title: state.uri.queryParameters['title']!,
    viewModel: context.read(),
    selectedTagId: _selectedTagId(state),
    onTagSelected: (tagId) =>
        context.go(_withQuery('/collection/tags/$tagId', state)),
    onBack: () => context.go('/'),
  );
}

Widget _favoritesScreen(BuildContext context, GoRouterState state) {
  return FavoritesScreen(
    viewModel: context.watch(),
    selectedTagId: _selectedTagId(state),
    onTagSelected: (tagId) => context.go('/favorites/tags/$tagId'),
    onBack: () => context.go('/'),
  );
}

Widget _viewListScreen(BuildContext context, GoRouterState state) {
  final listId = state.pathParameters['id']!;
  return ViewListScreen(
    listName: state.uri.queryParameters['name']!,
    viewModel: context.read(),
    selectedTagId: _selectedTagId(state),
    onTagSelected: (tagId) =>
        context.go(_withQuery('/lists/$listId/tags/$tagId', state)),
    onBack: () => context.go('/lists'),
  );
}

Widget _viewTagScreen(
  BuildContext context,
  int tagId, {
  required VoidCallback onShowDetails,
  bool showsBackButton = true,
}) {
  return ViewTagScreen(
    key: ValueKey(tagId),
    tagId: tagId,
    tagsRepository: context.read(),
    cacheManager: context.read(),
    listsViewModel: context.read(),
    sharePlus: context.read(),
    foldRepository: context.read(),
    onShowDetails: onShowDetails,
    showsBackButton: showsBackButton,
  );
}

Widget _tagDetailsScreen(int tagId) {
  return ChangeNotifierProvider(
    create: (context) =>
        ViewTagViewModel(repository: context.read(), tagId: tagId),
    child: Builder(
      builder: (context) => TagDetailsScreen(viewModel: context.read()),
    ),
  );
}

int? _selectedTagId(GoRouterState state) =>
    int.tryParse(state.pathParameters['tagId'] ?? '');

String _withQuery(String path, GoRouterState state) =>
    state.uri.query.isEmpty ? path : '$path?${state.uri.query}';
