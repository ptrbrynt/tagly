import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tagly/domain/barbershop_tag.dart';

class TagListTile extends StatelessWidget {
  const TagListTile({required this.tag, super.key});

  final BarbershopTag tag;

  NumberFormat get _downloadsFmt => NumberFormat.compact();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      title: Text(tag.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#${tag.id}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (tag.arranger != null || tag.downloaded != null)
            const SizedBox(height: 2),
          if (tag.arranger != null || tag.downloaded != null)
            Row(
              spacing: 12,
              children: [
                if (tag.arranger case final String arranger)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      Text(
                        arranger,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                if (tag.downloaded case final int downloads)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.download_rounded,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      Text(
                        _downloadsFmt.format(downloads),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        unawaited(context.push('/tag?id=${tag.id}'));
      },
    );
  }
}
