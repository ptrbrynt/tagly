import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/lists/view_list_view_model.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';
import 'package:tagly/presentation/utils/failure_card.dart';
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
      background: _dismissibleBackground(context, .centerLeft),
      secondaryBackground: _dismissibleBackground(context, .centerRight),
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
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => const _AddToListHelpSheet(),
      ),
    );
  }

  Widget _dismissibleBackground(
    BuildContext context,
    Alignment iconAlignment,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      padding: const .symmetric(horizontal: 16),
      child: Align(
        alignment: iconAlignment,
        child: Icon(
          Icons.remove_rounded,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
      ),
    );
  }
}

class _AddToListHelpSheet extends StatelessWidget {
  const _AddToListHelpSheet();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How to add Tags to a List', style: textTheme.titleLarge),
            const SizedBox(height: 24),
            const _HelpStep(
              number: 1,
              icon: Icons.more_vert_rounded,
              title: 'Open the tag menu',
              description:
                  'While viewing a Tag, tap the menu button (⋮) in the'
                  ' top-right corner.',
            ),
            const SizedBox(height: 20),
            const _HelpStep(
              number: 2,
              icon: Icons.playlist_add_rounded,
              title: 'Tap "Add to List"',
              description: 'Select "Add to List" from the menu.',
            ),
            const SizedBox(height: 20),
            const _HelpStep(
              number: 3,
              icon: Icons.checklist_rounded,
              title: 'Choose or create a List',
              description:
                  'Select an existing List, or tap "New List…" to create'
                  ' one and add the Tag to it.',
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpStep extends StatelessWidget {
  const _HelpStep({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  final int number;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: cs.primaryContainer,
          child: Icon(icon, size: 16, color: cs.onPrimaryContainer),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
