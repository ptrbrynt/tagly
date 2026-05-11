import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/lists/view_list_view_model.dart';
import 'package:tagly/presentation/search/search_screen.dart';

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
            Failure(:final message) => Center(child: Text(message)),
            Ok(:final value) => ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) => _listTile(context, value[index]),
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
      confirmDismiss: (_) async {
        final dialogResult = await showOkCancelAlertDialog(
          context: context,
          title: 'Remove tag from list?',
          isDestructiveAction: true,
        );
        return dialogResult == .ok;
      },
      onDismissed: (_) async {
        final result = await viewModel.removeTagFromList(tag.id);
        if (!context.mounted) return;
        if (result case Failure(:final message)) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: TagListTile(tag: tag),
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
