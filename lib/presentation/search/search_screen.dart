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
  // The query currently being searched for. If null, there is no pending
  // request.
  String? _searchingWithQuery;

  // The most recent options received from the API.
  late final Iterable<Widget> _lastOptions = <Widget>[];
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        final syncStatus = widget.repository.syncStatus;
        return syncStatus == .initialSync
            ? const Scaffold(body: InitialSyncWidget())
            : Scaffold(
                appBar: AppBar(
                  title: _searchBar(),
                  clipBehavior: .none,
                  toolbarHeight: kToolbarHeight + 16,
                  scrolledUnderElevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
                body: ListView(children: [_nearbyBanner()]),
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

        // If another search happened after this one, throw away these options.
        // Use the previous options instead and wait for the newer request to
        // finish.
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

class TagListTile extends StatelessWidget {
  const TagListTile({required this.tag, super.key});

  final BarbershopTag tag;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(tag.title),
      subtitle: Text('#${tag.id}'),
      onTap: () {
        context.go('/tag?id=${tag.id}');
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
