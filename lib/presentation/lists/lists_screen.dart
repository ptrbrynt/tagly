import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_list.dart';
import 'package:tagly/presentation/lists/lists_view_model.dart';
import 'package:tagly/presentation/utils/dismissible_background.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';
import 'package:tagly/presentation/utils/failure_card.dart';
import 'package:tagly/presentation/utils/fold_aware_dialogs.dart';
import 'package:tagly/presentation/utils/vertical_bar_controls.dart';

class ListsScreen extends StatelessWidget {
  const new({required this.viewModel, super.key});

  final ListsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return VerticalBarScaffold(
      title: const Text('Lists'),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Create List'),
        icon: const Icon(Icons.playlist_add),
        onPressed: () => _createList(context),
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
            Ok(:final value) =>
              value.isEmpty
                  ? const EmptyStateCard(child: Text('No lists added yet'))
                  : ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final list = value[index];
                        return _listTile(context, list);
                      },
                    ),
          };
        },
      ),
    );
  }

  Widget _listTile(BuildContext context, TagList list) {
    return Dismissible(
      key: ValueKey(list.id),
      background: DismissibleBackground.deleteForever(context, .centerLeft),
      secondaryBackground: DismissibleBackground.deleteForever(
        context,
        .centerRight,
      ),
      confirmDismiss: (_) async {
        return await showConfirmDialog(
          context: context,
          title: 'Delete List?',
          message:
              'Are you sure you want to delete this list? '
              'This cannot be undone!',
          confirmLabel: 'Delete',
          isDestructive: true,
        );
      },
      onDismissed: (_) async {
        final result = await viewModel.deleteList(list.id);
        if (!context.mounted) return;
        if (result case Failure(:final message)) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: ListTile(
        title: Text(list.name),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          unawaited(context.push('/lists/${list.id}?name=${list.name}'));
        },
      ),
    );
  }

  Future<void> _createList(BuildContext context) async {
    final listName = await showTextPromptDialog(
      context: context,
      title: 'New List',
      hintText: 'Awesome Tags',
      textCapitalization: .words,
    );
    if (listName == null) return;

    final result = await viewModel.createList(listName);

    if (!context.mounted) return;

    if (result case Failure(:final message)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
