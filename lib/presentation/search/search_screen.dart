import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/nearby/nearby_notifier.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    required this.repository,
    required this.nearby,
    super.key,
  });

  final TagsRepository repository;
  final NearbyNotifier nearby;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _searchingWithQuery;
  late final Iterable<Widget> _lastOptions = <Widget>[];

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
                      _nearbyBanner(),
                      Text(
                        'Tagly',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 24),
                      _searchBar(),
                      const SizedBox(height: 32),
                      Text(
                        'Browse',
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

  Widget _nearbyBanner() {
    return ListenableBuilder(
      listenable: widget.nearby,
      builder: (context, _) {
        final broadcast = widget.nearby.detectedBroadcast;
        if (broadcast == null) return const SizedBox.shrink();

        return MaterialBanner(
          content: Text('${broadcast.deviceName} is sharing a tag'),
          leading: const Icon(Icons.cell_tower),
          actions: [
            TextButton(
              onPressed: widget.nearby.dismissDetectedBroadcast,
              child: const Text('Dismiss'),
            ),
            FilledButton(
              onPressed: () {
                widget.nearby.dismissDetectedBroadcast();
                unawaited(context.push('/tag?id=${broadcast.tagId}'));
              },
              child: const Text('Open'),
            ),
          ],
        );
      },
    );
  }

  Widget _searchBar() {
    return SearchAnchor.bar(
      barHintText: 'Search tags...',
      suggestionsBuilder: (context, controller) async {
        _searchingWithQuery = controller.text;
        final result = await widget.repository.searchTags(_searchingWithQuery!);

        if (_searchingWithQuery != controller.text) {
          return _lastOptions;
        }

        return switch (result) {
          Failure() => [],
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

class TagListTile extends StatelessWidget {
  const TagListTile({required this.tag, super.key});

  final BarbershopTag tag;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(tag.title),
      subtitle: Text('#${tag.id}'),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        unawaited(context.push('/tag?id=${tag.id}'));
      },
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
