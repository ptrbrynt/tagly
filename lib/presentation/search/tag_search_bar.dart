import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_search_query.dart';
import 'package:tagly/presentation/search/search_filters_sheet.dart';
import 'package:tagly/presentation/utils/help_sheet.dart';
import 'package:tagly/presentation/utils/tag_list_tile.dart';

class TagSearchBar extends StatefulWidget {
  const TagSearchBar({required this.repository, super.key});

  final TagsRepository repository;

  @override
  State<TagSearchBar> createState() => _TagSearchBarState();
}

class _TagSearchBarState extends State<TagSearchBar> {
  final ValueNotifier<TagSearchQuery> _queryNotifier = ValueNotifier(
    const TagSearchQuery(),
  );
  final _searchController = SearchController();

  @override
  void dispose() {
    _searchController.dispose();
    _queryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      searchController: _searchController,
      barHintText: 'Search or enter an ID...',

      viewTrailing: [
        ValueListenableBuilder<TagSearchQuery>(
          valueListenable: _queryNotifier,
          builder: (context, query, _) {
            return (query.text?.isNotEmpty ?? false)
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: _searchController.clear,
                  )
                : const SizedBox.shrink();
          },
        ),
        ValueListenableBuilder<TagSearchQuery>(
          valueListenable: _queryNotifier,
          builder: (context, query, _) => IconButton(
            icon: Badge(
              isLabelVisible: query.hasFilters,
              child: const Icon(Icons.filter_list_rounded),
            ),
            onPressed: _showFilters,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline_rounded),
          onPressed: _showHelp,
        ),
      ],
      suggestionsBuilder: (context, controller) async {
        _queryNotifier.value = _queryNotifier.value.copyWith(
          text: controller.text.trim(),
        );

        final result = await widget.repository.searchTags(_queryNotifier.value);

        return switch (result) {
          Failure() => const [],
          Ok(:final value) => [for (final tag in value) TagListTile(tag: tag)],
        };
      },
    );
  }

  Future<void> _showFilters() async {
    final result = await showModalBottomSheet<TagSearchQuery>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => SearchFiltersSheet(
        initialQuery: _queryNotifier.value,
        repository: widget.repository,
      ),
    );
    if (result != null) {
      _queryNotifier.value = result;
      // Toggle a trailing space to force suggestionsBuilder to re-run.
      // The .trim() in suggestionsBuilder ensures this never affects search.
      final text = result.text ?? '';
      _searchController.text = text.endsWith(' ') ? text.trimRight() : '$text ';
      _searchController.text = text.trimRight();
    }
  }

  Future<void> _showHelp() async {
    unawaited(
      HelpSheet.show(
        context: context,
        title: 'How to use Search',
        steps: [
          const HelpStep(
            icon: Icons.search_rounded,
            title: 'Type a query',
            description:
                'You can search for tag titles, arrangers, quartets/choruses, '
                'learning track makers, or lyrics.',
          ),
          const HelpStep(
            icon: Icons.filter_list_rounded,
            title: 'Use filters',
            description:
                'Narrow down your search by voicing or '
                'number of parts, and choose how to sort your search results.',
          ),
          const HelpStep(
            icon: Icons.numbers_rounded,
            title: 'Type an ID',
            description:
                'If you know the ID of the tag you want, just type it in. '
                'This works for IDs from any other barbershoptags.com app.',
          ),
        ],
      ),
    );
  }
}
