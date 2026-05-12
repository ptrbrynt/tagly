import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_search_query.dart';
import 'package:tagly/presentation/utils/tag_list_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    required this.repository,
    super.key,
  });

  final TagsRepository repository;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        final syncStatus = widget.repository.syncStatus;
        if (syncStatus == .initialSync) {
          return const Scaffold(body: InitialSyncWidget());
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
                      _searchBar(),
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

  Widget _searchBar() {
    return SearchAnchor.bar(
      barHintText: 'Search tags...',
      suggestionsBuilder: (context, controller) async {
        if (controller.text.isEmpty) return [];

        final result = await widget.repository.searchTags(
          TagSearchQuery(text: controller.text),
        );

        return switch (result) {
          Failure() => const [],
          Ok(:final value) => [for (final tag in value) TagListTile(tag: tag)],
        };
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

class InitialSyncWidget extends StatelessWidget {
  const InitialSyncWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(24),
      alignment: .center,
      child: const Column(
        mainAxisAlignment: .center,
        children: [
          CircularProgressIndicator.adaptive(),
          SizedBox(height: 40),
          Text('Tagly is syncing', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Give us a few seconds to get you set up'),
        ],
      ),
    );
  }
}
