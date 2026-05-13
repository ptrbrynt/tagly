import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/lists/view_list_view_model.dart';
import 'package:tagly/presentation/utils/dismissible_background.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';
import 'package:tagly/presentation/utils/failure_card.dart';
import 'package:tagly/presentation/utils/help_sheet.dart';
import 'package:tagly/presentation/utils/tag_list_tile.dart';

class ViewListScreen extends StatelessWidget {
  const ViewListScreen({
    required this.listName,
    required this.viewModel,
    super.key,
  });

  final String listName;
  final ViewListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(listName)),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return switch (viewModel.result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => FailureCard(
              message: message,
              onRetry: viewModel.load,
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
      child: TagListTile(tag: tag),
    );
  }

  Future<void> _removeTagFromList(BuildContext context, int tagId) async {
    final result = await viewModel.removeTagFromList(tagId);
    if (!context.mounted) return;
    if (result case Failure(:final message)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tag removed from list'),
          persist: false,
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await viewModel.addTagToList(tagId);
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
            icon: Icons.more_vert_rounded,
            title: 'Open the tag menu',
            description:
                'While viewing a Tag, tap the menu button (⋮) in the'
                ' top-right corner.',
          ),
          const HelpStep(
            icon: Icons.playlist_add_rounded,
            title: 'Tap "Add to List"',
            description: 'Select "Add to List" from the menu.',
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
