import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/adaptive/tagly_scaffold.dart';
import 'package:tagly/presentation/lists/view_list_view_model.dart';
import 'package:tagly/presentation/utils/dismissible_background.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';
import 'package:tagly/presentation/utils/failure_card.dart';
import 'package:tagly/presentation/utils/help_sheet.dart';
import 'package:tagly/presentation/utils/tag_list_tile.dart';

class ViewListScreen extends StatefulWidget {
  const new({
    required this.listId,
    required this.listName,
    required this.repository,
    required this.onTagSelected,
    this.selectedTagId,
    super.key,
  });

  final int listId;
  final String listName;
  final TagsRepository repository;
  final ValueChanged<int> onTagSelected;
  final int? selectedTagId;

  @override
  State<ViewListScreen> createState() => _ViewListScreenState();
}

class _ViewListScreenState extends State<ViewListScreen> {
  late final ViewListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ViewListViewModel(
      listId: widget.listId,
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
    return TaglyScaffold(
      title: widget.listName,
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return switch (_viewModel.result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => FailureCard(
              message: message,
              onRetry: _viewModel.load,
            ),
            Ok(:final value) =>
              value.isEmpty
                  ? EmptyStateCard(
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          const SizedBox(height: 16),
                          const Text('No tags added to this list yet'),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            icon: const Icon(Icons.help_outline_rounded),
                            label: const Text('How do I add tags to lists?'),
                            onPressed: () => _showHelp(context),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) =>
                          _listTile(context, value[index]),
                    ),
          };
        },
      ),
    );
  }

  Widget _listTile(BuildContext context, BarbershopTag tag) {
    return Dismissible(
      key: ValueKey(tag.id),
      background: DismissibleBackground.remove(context, .centerLeft),
      secondaryBackground: DismissibleBackground.remove(context, .centerRight),
      onDismissed: (_) async {
        await _removeTagFromList(context, tag.id);
      },
      child: TagListTile(
        tag: tag,
        selected: tag.id == widget.selectedTagId,
        onTap: () => widget.onTagSelected(tag.id),
      ),
    );
  }

  Future<void> _removeTagFromList(BuildContext context, int tagId) async {
    final result = await _viewModel.removeTagFromList(tagId);
    if (!context.mounted) return;
    if (result case Failure(:final message)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tag removed from list'),
          persist: false,
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await _viewModel.addTagToList(tagId);
            },
          ),
        ),
      );
    }
  }

  void _showHelp(BuildContext context) {
    unawaited(
      HelpSheet.show(
        context: context,
        title: 'How to add Tags to a List',
        steps: [
          const HelpStep(
            icon: Icons.search_rounded,
            title: 'Open a tag',
            description: 'Find a tag you want to add to this List.',
          ),
          const HelpStep(
            icon: Icons.playlist_add_rounded,
            title: 'Tap "Add to List"',
            description:
                "Tap Add to List in the toolbar. If you can't see it, "
                'look in the More (…) menu.',
          ),
          const HelpStep(
            icon: Icons.checklist_rounded,
            title: 'Choose or create a List',
            description:
                'Select an existing List, or tap "New List…" to create'
                ' one and add the Tag to it.',
          ),
        ],
      ),
    );
  }
}
