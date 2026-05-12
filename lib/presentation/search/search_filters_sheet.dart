import 'package:flutter/material.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_search_query.dart';

class SearchFiltersSheet extends StatefulWidget {
  const SearchFiltersSheet({
    required this.repository,
    required this.initialQuery,
    this.resetTo = const TagSearchQuery(),
    super.key,
  });

  final TagsRepository repository;
  final TagSearchQuery initialQuery;
  final TagSearchQuery resetTo;

  @override
  State<SearchFiltersSheet> createState() => _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends State<SearchFiltersSheet> {
  late TagSortOrder _sortOrder;
  late Set<int> _numParts;
  late Set<String> _voicings;

  List<String> _voicingOptions = [];

  @override
  void initState() {
    super.initState();
    _sortOrder = widget.initialQuery.sortOrder;
    _numParts = Set.from(widget.initialQuery.numParts ?? []);
    _voicings = Set.from(widget.initialQuery.voicings ?? []);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.repository.availableVoicings().then((r) {
        debugPrint(r.toString());
        if (mounted) {
          setState(() {
            _voicingOptions = switch (r) {
              Ok(:final value) => value,
              _ => [],
            };
          });
        }
      });
    });
  }

  void _reset() {
    final defaults = widget.resetTo;
    setState(() {
      _sortOrder = defaults.sortOrder;
      _numParts = Set.of(defaults.numParts ?? []);
      _voicings = Set.of(defaults.voicings ?? []);
    });
  }

  void _apply() {
    final updated = widget.initialQuery.copyWith(
      sortOrder: _sortOrder,
      numParts: _numParts.isEmpty ? null : (_numParts.toList()..sort()),
      voicings: _voicings.isEmpty ? null : (_voicings.toList()..sort()),
    );
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Text('Filters', style: theme.textTheme.titleLarge),
              const Spacer(),
              TextButton(onPressed: _reset, child: const Text('Reset')),
            ],
          ),
          const SizedBox(height: 16),
          Text('Sort by', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final order in TagSortOrder.values)
                ChoiceChip(
                  label: Text(_sortLabel(order)),
                  selected: _sortOrder == order,
                  onSelected: (_) => setState(() => _sortOrder = order),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Number of parts', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final n in [2, 3, 4, 5, 6, 7, 8])
                FilterChip(
                  label: Text('$n parts'),
                  selected: _numParts.contains(n),
                  onSelected: (selected) => setState(() {
                    selected ? _numParts.add(n) : _numParts.remove(n);
                  }),
                ),
            ],
          ),
          if (_voicingOptions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Voicing', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final i in _voicingOptions)
                  FilterChip(
                    label: Text(i),
                    selected: _voicings.contains(i),
                    onSelected: (selected) => setState(() {
                      selected ? _voicings.add(i) : _voicings.remove(i);
                    }),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          FilledButton(onPressed: _apply, child: const Text('Apply filters')),
          const SafeArea(
            top: false,
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }

  static String _sortLabel(TagSortOrder order) => switch (order) {
    TagSortOrder.downloadsDesc => 'Most popular',
    TagSortOrder.ratingDesc => 'Highest rated',
    TagSortOrder.dateDesc => 'Newest',
    TagSortOrder.titleAsc => 'Title (A–Z)',
    TagSortOrder.id => 'ID',
  };
}
