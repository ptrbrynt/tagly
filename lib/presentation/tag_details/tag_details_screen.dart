import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/nearby/nearby_notifier.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';

class TagDetailsScreen extends StatelessWidget {
  const TagDetailsScreen({
    required this.viewModel,
    required this.nearby,
    super.key,
  });

  final ViewTagViewModel viewModel;
  final NearbyNotifier nearby;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final result = viewModel.result;
        return Scaffold(
          appBar: AppBar(title: Text('#${viewModel.tagId}')),
          body: switch (result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => Center(child: Text(message)),
            Ok(:final value) => _body(value),
          },
        );
      },
    );
  }

  Widget _body(BarbershopTag tag) {
    final ratingFormat = NumberFormat.decimalPatternDigits(
      decimalDigits: 2,
    );
    final downloadsFormat = NumberFormat.compact();
    return ListView(
      children: [
        ListTile(
          title: Text(tag.title),
          subtitle: const Text('Title'),
        ),
        if (tag.altTitle != null)
          ListTile(
            title: Text(tag.altTitle!),
            subtitle: const Text('Alt Title'),
          ),
        if (tag.keyName != null)
          ListTile(
            title: Text(tag.keyName!),
            subtitle: const Text('Written Key'),
          ),
        if (tag.arranger != null)
          ListTile(
            title: Text(tag.arranger!),
            subtitle: const Text('Arranger'),
          ),
        if (tag.quartet != null)
          ListTile(
            title: Text(tag.quartet!),
            subtitle: const Text('Tracks'),
          ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.download_rounded),
          title: Text(downloadsFormat.format(tag.downloaded ?? 0)),
          subtitle: const Text('Downloads'),
        ),
        ListTile(
          leading: const Icon(Icons.star_rate_rounded),
          title: Text(
            ratingFormat.format(tag.rating ?? 0),
          ),
          subtitle: const Text('Rating'),
        ),
        if (tag.posted != null)
          ListTile(
            leading: const Icon(Icons.calendar_today_rounded),
            title: Text(_formatDate(tag.posted!)),
            subtitle: const Text('Posted'),
          ),
      ],
    );
  }
}

String _formatDate(String iso) {
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  return DateFormat.yMMMd().format(date);
}
