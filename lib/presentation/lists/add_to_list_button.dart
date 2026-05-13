import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tagly/domain/tag_list.dart';

class AddToListButton extends StatefulWidget {
  const AddToListButton({
    required this.lists,
    required this.onListSelected,
    required this.onCreateListSelected,
    required this.tagId,
    super.key,
  });

  final int tagId;
  final List<TagList> lists;
  final FutureOr<void> Function(int listId) onListSelected;
  final FutureOr<void> Function() onCreateListSelected;

  @override
  State<AddToListButton> createState() => _AddToListButtonState();
}

class _AddToListButtonState extends State<AddToListButton> {
  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
      menuChildren: [
        for (final list in widget.lists)
          MenuItemButton(
            onPressed: () => widget.onListSelected(list.id),
            child: Text(list.name),
          ),

        MenuItemButton(
          onPressed: widget.onCreateListSelected,
          leadingIcon: const Icon(Icons.add_rounded),
          child: const Text('New List...'),
        ),
      ],
      leadingIcon: const Icon(Icons.playlist_add_rounded),
      child: const Text('Add to List'),
    );
  }
}
