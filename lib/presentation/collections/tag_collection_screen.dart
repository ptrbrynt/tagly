import 'package:material_ui/material_ui.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_search_query.dart';
import 'package:tagly/presentation/collections/tag_collection_view_model.dart';
import 'package:tagly/presentation/search/search_filters_sheet.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';
import 'package:tagly/presentation/utils/failure_card.dart';
import 'package:tagly/presentation/utils/tag_list_tile.dart';

class TagCollectionScreen extends StatelessWidget {
  const new({
    required this.title,
    required this.viewModel,
    required this.onTagSelected,
    required this.onBack,
    this.selectedTagId,
    super.key,
  });

  final String title;
  final TagCollectionViewModel viewModel;
  final ValueChanged<int> onTagSelected;
  final VoidCallback onBack;
  final int? selectedTagId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: onBack),
        title: Text(title),
        actions: [
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return IconButton(
                icon: Badge(
                  isLabelVisible: viewModel.query != viewModel.initialQuery,
                  child: const Icon(Icons.filter_list_rounded),
                ),
                onPressed: () => _showFilters(context),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return switch (viewModel.result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => FailureCard(
              message: message,
              onRetry: viewModel.load,
            ),
            Ok(value: []) => const EmptyStateCard(child: Text('No results')),
            Ok(:final value) => ListView.builder(
              key: const PageStorageKey('tags'),
              itemCount: value.length,
              itemBuilder: (context, index) => TagListTile(
                tag: value[index],
                selected: value[index].id == selectedTagId,
                onTap: () => onTagSelected(value[index].id),
              ),
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
        initialQuery: viewModel.query,
        repository: viewModel.repository,
        resetTo: viewModel.initialQuery,
      ),
    );
    if (result != null) {
      viewModel.updateQuery(result);
    }
  }
}
