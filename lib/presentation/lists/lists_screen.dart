import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_list.dart';
import 'package:tagly/presentation/lists/lists_view_model.dart';

class ListsScreen extends StatelessWidget {
  const ListsScreen({required this.viewModel, super.key});

  final ListsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lists'),
        actions: [
          IconButton.filledTonal(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _createList(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return switch (viewModel.result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => Center(child: Text(message)),
            Ok(:final value) => ListView.builder(
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
      background: _dismissibleBackground(context, .centerLeft),
      secondaryBackground: _dismissibleBackground(context, .centerRight),
      confirmDismiss: (_) async {
        final confirmResult = await showOkCancelAlertDialog(
          context: context,
          title: 'Delete List?',
          message:
              '''Are you sure you want to delete this list? This cannot be undone!''',
          isDestructiveAction: true,
        );

        return confirmResult == .ok;
      },
      onDismissed: (_) async {
        final result = await viewModel.deleteList(list.id);
        if (!context.mounted) return;
        if (result case Failure(:final message)) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
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

  Widget _dismissibleBackground(
    BuildContext context,
    Alignment iconAlignment,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.error,
      padding: const .symmetric(horizontal: 16),
      child: Align(
        alignment: iconAlignment,
        child: Icon(
          Icons.delete_forever_rounded,
          color: Theme.of(context).colorScheme.onError,
        ),
      ),
    );
  }

  Future<void> _createList(BuildContext context) async {
    final promptResult = await showTextInputDialog(
      context: context,
      title: 'New List',
      textFields: [
        const DialogTextField(
          hintText: 'Awesome Tags',
          textCapitalization: .words,
        ),
      ],
    );
    if (promptResult == null || promptResult.isEmpty) return;

    final listName = promptResult.first;

    final result = await viewModel.createList(listName);

    if (!context.mounted) return;

    if (result case Failure(:final message)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
