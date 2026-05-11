import 'dart:async';

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
  List<TagList>? _lists;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLists());
  }

  Future<void> _loadLists() async {
    final result = await widget.listsRepository.getLists();
    if (!mounted) return;
    if (result case Ok(:final value)) {
      setState(() {
        _lists = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_lists) {
      null || [] => const MenuItemButton(
        leadingIcon: Icon(Icons.playlist_add_rounded),
        child: Text('Add to List'),
      ),
      final lists => SubmenuButton(
        menuChildren: [
          for (final list in lists)
            MenuItemButton(
              onPressed: () => widget.onListSelected(list.id),
              child: Text(list.name),
            ),
        ],
        leadingIcon: const Icon(Icons.playlist_add_rounded),
        child: const Text('Add to List'),
      ),
    };
  }
}
