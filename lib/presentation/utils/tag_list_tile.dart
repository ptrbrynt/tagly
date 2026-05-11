import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tagly/domain/barbershop_tag.dart';

class TagListTile extends StatelessWidget {
  const TagListTile({required this.tag, super.key});

  final BarbershopTag tag;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(tag.title),
      subtitle: Text('#${tag.id}'),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        unawaited(context.push('/tag?id=${tag.id}'));
      },
    );
  }
}
