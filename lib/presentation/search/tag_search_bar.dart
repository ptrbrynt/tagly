import 'package:flutter/material.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_search_query.dart';
import 'package:tagly/presentation/search/search_filters_sheet.dart';
import 'package:tagly/presentation/utils/tag_list_tile.dart';

class TagSearchBar extends StatefulWidget {
  const TagSearchBar({required this.repository, super.key});

  final TagsRepository repository;

  @override
  State<TagSearchBar> createState() => _TagSearchBarState();
}

class _TagSearchBarState extends State<TagSearchBar> {
  final ValueNotifier<TagSearchQuery> _queryNotifier =
      ValueNotifier(const TagSearchQuery());
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
      barHintText: 'Search tags...',
      viewTrailing: [
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
      ],
      suggestionsBuilder: (context, controller) async {
        _queryNotifier.value =
            _queryNotifier.value.copyWith(text: controller.text.trim());

        final result =
            await widget.repository.searchTags(_queryNotifier.value);

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
}
