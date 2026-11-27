import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_search_query.dart';
import 'package:tagly/presentation/search/search_filters_sheet.dart';
import 'package:tagly/presentation/utils/fold_display_feature.dart';
import 'package:tagly/presentation/utils/help_sheet.dart';
import 'package:tagly/presentation/utils/list_detail_layout.dart';
import 'package:tagly/presentation/utils/tag_list_tile.dart';
import 'package:tagly/presentation/utils/vertical_bar_controls.dart';

class TagSearchBar extends StatefulWidget {
  const new({
    required this.repository,
    required this.onTagSelected,
    required this.onResultSelected,
    super.key,
  });

  final TagsRepository repository;

  /// Opens a tag over the search results, which stay open beneath it.
  final ValueChanged<int> onTagSelected;

  /// Opens a tag beside the results of [TagSearchQuery], on windows wide
  /// enough for two panes. The search view closes first.
  final void Function(TagSearchQuery query, int tagId) onResultSelected;

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

      // While the system's vertical bar shows, the search view's buttons
      // move into its column, as the app's other bars do, and only the field
      // and its clear button stay at the top. The search view keeps the
      // widgets it opened with, so each decides when it builds, as the bar
      // comes and goes with the device opening and closing.
      viewLeading: Builder(
        builder: (context) => _inVerticalBar(context)
            ? SizedBox(width: cornerPadding(context).left)
            : const BackButton(),
      ),
      viewTrailing: [
        _clearButton(),
        _outsideVerticalBar(_filterButton()),
        _outsideVerticalBar(_helpButton()),
      ],
      viewBuilder: (suggestions) => VerticalBarControls(
        groups: [
          const [BackButton()],
          [_filterButton(), _helpButton()],
        ],
        builder: (context, {required inVerticalBar}) =>
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                padding: .only(bottom: MediaQuery.viewInsetsOf(context).bottom),
                children: suggestions.toList(),
              ),
            ),
      ),
      suggestionsBuilder: (context, controller) async {
        _queryNotifier.value = _queryNotifier.value.copyWith(
          text: controller.text.trim(),
        );

        final result = await widget.repository.searchTags(_queryNotifier.value);

        return switch (result) {
          Failure() => const [],
          Ok(:final value) => [
            for (final tag in value)
              TagListTile(tag: tag, onTap: () => _open(tag.id)),
          ],
        };
      },
    );
  }

  static bool _inVerticalBar(BuildContext context) =>
      VerticalBarScope.of(context) != null;

  static Widget _outsideVerticalBar(Widget child) => Builder(
    builder: (context) =>
        _inVerticalBar(context) ? const SizedBox.shrink() : child,
  );

  Widget _clearButton() {
    return ValueListenableBuilder<TagSearchQuery>(
      valueListenable: _queryNotifier,
      builder: (context, query, _) {
        return (query.text?.isNotEmpty ?? false)
            ? IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: _searchController.clear,
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _filterButton() {
    return ValueListenableBuilder<TagSearchQuery>(
      valueListenable: _queryNotifier,
      builder: (context, query, _) => IconButton(
        icon: Badge(
          isLabelVisible: query.hasFilters,
          child: const Icon(Icons.filter_list_rounded),
        ),
        tooltip: 'Filters',
        onPressed: _showFilters,
      ),
    );
  }

  Widget _helpButton() {
    return IconButton(
      icon: const Icon(Icons.help_outline_rounded),
      tooltip: 'Help',
      onPressed: _showHelp,
    );
  }

  void _open(int tagId) {
    if (!fitsTwoPanes(context)) {
      widget.onTagSelected(tagId);
      return;
    }
    final query = _queryNotifier.value;
    _searchController.closeView(_searchController.text);
    widget.onResultSelected(query, tagId);
  }

  Future<void> _showFilters() async {
    final result = await showModalBottomSheet<TagSearchQuery>(
      context: context,
      anchorPoint: foldAwareAnchor(context),
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
