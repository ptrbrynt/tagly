import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tagly/data/lists_repository.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_list.dart';

class AddToListButton extends StatefulWidget {
  const AddToListButton({
    required this.listsRepository,
    required this.onListSelected,
    required this.tagId,
    super.key,
  });

  final int tagId;
  final ListsRepository listsRepository;
  final FutureOr<void> Function(int listId) onListSelected;

  @override
  State<AddToListButton> createState() => _AddToListButtonState();
}

class _AddToListButtonState extends State<AddToListButton> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.playlist_add),
      onPressed: _loading
          ? null
          : () async {
              setState(() {
                _loading = true;
              });
              await _onPressed();
              if (mounted) {
                setState(() {
                  _loading = false;
                });
              }
            },
    );
  }

  Future<void> _onPressed() async {
    final listsResult = await widget.listsRepository.getLists();

    if (!mounted) return;

    if (listsResult case Failure(:final message)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    final lists = (listsResult as Ok<List<TagList>>).value;

    if (lists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You haven't created any lists yet.")),
      );
      return;
    }

    final dialogResult = await showConfirmationDialog(
      context: context,
      title: 'Add Tag to List',
      style: .material,
      actions: [
        for (final list in lists)
          AlertDialogAction(key: list.id, label: list.name),
      ],
    );

    if (dialogResult == null) return;
    if (!mounted) return;

    final result = await widget.onListSelected(dialogResult);

    if (!mounted) return;

    if (result case Failure(:final message)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }
  }
}
