import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/barbershop_tag_video.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/nearby/nearby_notifier.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';

class TagDetailsScreen extends StatelessWidget {
  const TagDetailsScreen({
    super.key,
    required this.viewModel,
    required this.nearby,
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
          appBar: AppBar(
            title: result is Ok<BarbershopTag>
                ? Text(result.value.title)
                : const Text('Tag Details'),
          ),
          body: switch (result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => Center(child: Text(message)),
            Ok(:final value) => _TagBody(tag: value),
          },
        );
      },
    );
  }
}

class _TagBody extends StatelessWidget {
  const _TagBody({required this.tag});

  final BarbershopTag tag;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            sliver: SliverList.list(
              children: [
                if (tag.altTitle != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      tag.altTitle!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                _HeaderChips(tag: tag),
                if (tag.rating != null) ...[
                  const SizedBox(height: 12),
                  _RatingRow(
                    rating: tag.rating!,
                    count: tag.ratingCount,
                    downloaded: tag.downloaded,
                  ),
                ],
                ..._infoSections(tag),
                if (tag.notes case final notes? when notes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _ExpandableText(title: 'Notes', content: notes),
                ],
                if (tag.videos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _VideosSection(videos: tag.videos),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<Widget> _infoSections(BarbershopTag tag) {
  final sections = <Widget>[];

  void addSection(String title, List<(String, String)> rows) {
    if (rows.isEmpty) return;
    sections.add(const SizedBox(height: 16));
    sections.add(_InfoSection(title: title, rows: rows));
  }

  addSection('Details', [
    if (tag.arranger case final v?) ('Arranged by', v),
    if (tag.collection case final v?) ('Collection', v),
    if (tag.version case final v?) ('Version', v),
    if (tag.sungBy case final v?) ('As sung by', v),
    if (tag.quartet case final v?) ('Learning tracks', v),
    if (tag.posted case final v?) ('Posted', _formatDate(v)),
  ]);

  return sections;
}

class _HeaderChips extends StatelessWidget {
  const _HeaderChips({required this.tag});

  final BarbershopTag tag;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final primaryContainer = Theme.of(context).colorScheme.primaryContainer;

    final chips = <Widget>[
      if (tag.keyTonic != null || tag.keyMode != null)
        Chip(
          avatar: const Icon(Icons.music_note, size: 16),
          label: Text(
            _decodeHtmlEntities([tag.keyTonic, tag.keyMode].nonNulls.join(' ')),
          ),
        ),
      if (tag.parts case final v?) Chip(label: Text('$v parts')),
      if (tag.type case final v?) Chip(label: Text(v)),
      if (tag.isClassic)
        Chip(
          avatar: Icon(Icons.star, size: 16, color: primary),
          label: const Text('Classic'),
          backgroundColor: primaryContainer,
        ),
    ];

    if (chips.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(spacing: 8, runSpacing: 4, children: chips),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating, this.count, this.downloaded});

  final double rating;
  final int? count;
  final int? downloaded;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final subtle = Theme.of(context).colorScheme.onSurfaceVariant;
    final full = rating.floor();
    final hasHalf = (rating - full) >= 0.5;

    return Row(
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < full
                ? Icons.star
                : (i == full && hasHalf)
                ? Icons.star_half
                : Icons.star_border,
            size: 18,
            color: primary,
          ),
        const SizedBox(width: 6),
        Text(rating.toStringAsFixed(1)),
        if (count != null)
          Text(' ($count)', style: TextStyle(color: subtle, fontSize: 12)),
        if (downloaded != null) ...[
          const Spacer(),
          Icon(Icons.download_outlined, size: 16, color: subtle),
          const SizedBox(width: 2),
          Text('$downloaded', style: TextStyle(color: subtle, fontSize: 12)),
        ],
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.rows});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 108,
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
              ],
            ),
          ),
      ],
    );
  }
}

class _ExpandableText extends StatelessWidget {
  const _ExpandableText({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ExpansionTile(
        title: Text(title),
        shape: const Border(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SelectableText(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideosSection extends StatelessWidget {
  const _VideosSection({required this.videos});

  final List<BarbershopTagVideo> videos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Videos',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        for (final video in videos) _VideoCard(video: video),
      ],
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video});

  final BarbershopTagVideo video;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyStr = _decodeHtmlEntities(
      [video.sungKeyTonic, video.sungKeyMode].nonNulls.join(' '),
    );

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (video.youtubeCode != null)
                  const Icon(Icons.smart_display_outlined, size: 20),
                if (video.facebookUrl != null)
                  const Icon(Icons.play_circle_outline, size: 20),
                if (keyStr.isNotEmpty) _MiniChip(label: keyStr),
                if (video.isMultitrack) _MiniChip(label: 'Multitrack'),
              ],
            ),
            if (video.sungBy case final v?) ...[
              const SizedBox(height: 6),
              Text(v, style: theme.textTheme.bodyMedium),
            ],
            if (video.description case final desc? when desc.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                desc,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _formatDate(String iso) {
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  return DateFormat.yMMMd().format(date);
}

String _decodeHtmlEntities(String s) => s
    .replaceAll('&#9837;', '♭')
    .replaceAll('&#9839;', '♯')
    .replaceAll('&#9838;', '♮')
    .replaceAll('&amp;', '&')
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>');

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}
