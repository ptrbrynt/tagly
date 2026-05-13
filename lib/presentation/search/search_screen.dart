import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/tag_search_query.dart';
import 'package:tagly/presentation/search/tag_search_bar.dart';
import 'package:tagly/presentation/utils/initial_sync_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    required this.repository,
    super.key,
  });

  final TagsRepository repository;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final syncStatus = repository.syncStatus;
        if (syncStatus == .initialSync) {
          return const Scaffold(body: InitialSyncWidget());
        }
        if (syncStatus == .initialSyncFailed) {
          return Scaffold(
            body: InitialSyncWidget(
              onRetry: () => repository.syncTags().ignore(),
            ),
          );
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverSafeArea(
                sliver: SliverPadding(
                  padding: const .fromLTRB(24, 32, 24, 8),
                  sliver: SliverList.list(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Tagly',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.settings_rounded),
                            onPressed: () => context.go('/settings'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TagSearchBar(repository: repository),
                      const SizedBox(height: 32),
                      Text(
                        'My Collections',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _NavCard(
                        label: 'Favorites',
                        icon: Icons.favorite_rounded,
                        onTap: () => context.go('/favorites'),
                      ),
                      const SizedBox(height: 8),
                      _NavCard(
                        label: 'Lists',
                        icon: Icons.list_rounded,
                        onTap: () => context.go('/lists'),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Browse',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _NavCard(
                        label: 'Popular Tags',
                        icon: Icons.whatshot_rounded,
                        onTap: () {
                          const query = TagSearchQuery();
                          context.go(
                            '/collection?title=Popular Tags&${query.asQueryParameters()}',
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _NavCard(
                        label: 'Highest Rated Tags',
                        icon: Icons.star_rounded,
                        onTap: () {
                          const query = TagSearchQuery(sortOrder: .ratingDesc);
                          context.go(
                            '/collection?title=Highest Rated Tags&${query.asQueryParameters()}',
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _NavCard(
                        label: 'New Tags',
                        icon: Icons.new_releases_rounded,
                        onTap: () {
                          const query = TagSearchQuery(sortOrder: .dateDesc);
                          context.go(
                            '/collection?title=New Tags&${query.asQueryParameters()}',
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _NavCard(
                        label: 'Classic Tags',
                        icon: Icons.book_rounded,
                        onTap: () {
                          const query = TagSearchQuery(
                            isClassic: true,
                            sortOrder: .id,
                          );
                          context.go(
                            '/collection?title=Classic Tags&${query.asQueryParameters()}',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card.outlined(
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const .symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: cs.primary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
