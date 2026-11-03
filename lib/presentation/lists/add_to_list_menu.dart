import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tagly/domain/tag_list.dart';

List<Widget> addToListMenuItems({
  required List<TagList> lists,
  required FutureOr<void> Function(int listId) onListSelected,
  required FutureOr<void> Function() onCreateListSelected,
}) => [
  for (final list in lists)
    MenuItemButton(
      onPressed: () => onListSelected(list.id),
      child: Text(list.name),
    ),
  if (lists.isNotEmpty) const Divider(),
  MenuItemButton(
    onPressed: onCreateListSelected,
    leadingIcon: const Icon(Icons.add_rounded),
    child: const Text('New List...'),
  ),
];
