import 'package:flutter/material.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_search_query.dart';
import 'package:tagly/presentation/collections/tag_collection_view_model.dart';
import 'package:tagly/presentation/search/search_filters_sheet.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';
import 'package:tagly/presentation/utils/failure_card.dart';
import 'package:tagly/presentation/utils/tag_list_tile.dart';

class TagCollectionScreen extends StatefulWidget {
  const TagCollectionScreen({
    required this.title,
    required this.initialQuery,
    required this.repository,
    super.key,
  });

  final String title;
  final TagSearchQuery initialQuery;
  final TagsRepository repository;

  @override
  State<TagCollectionScreen> createState() => _TagCollectionScreenState();
}

class _TagCollectionScreenState extends State<TagCollectionScreen> {
  late final TagCollectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TagCollectionViewModel(
      initialQuery: widget.initialQuery,
      repository: widget.repository,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return IconButton(
                icon: Badge(
                  isLabelVisible: _viewModel.query != _viewModel.initialQuery,
                  child: const Icon(Icons.filter_list_rounded),
                ),
                onPressed: () => _showFilters(context),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return switch (_viewModel.result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => FailureCard(
              message: message,
              onRetry: _viewModel.load,
            ),
            Ok(value: []) => const EmptyStateCard(child: Text('No results')),
            Ok(:final value) => ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) => TagListTile(tag: value[index]),
            ),
          };
        },
      ),
    );
  }

  Future<void> _showFilters(BuildContext context) async {
    final result = await showModalBottomSheet<TagSearchQuery>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => SearchFiltersSheet(
        initialQuery: _viewModel.query,
        repository: _viewModel.repository,
        resetTo: _viewModel.initialQuery,
      ),
    );
    if (result != null) {
      _viewModel.updateQuery(result);
    }
  }
}
