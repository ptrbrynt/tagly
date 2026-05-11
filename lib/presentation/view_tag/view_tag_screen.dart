import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/nearby/nearby_notifier.dart';
import 'package:tagly/presentation/audio_player/learning_track_player.dart';
import 'package:tagly/presentation/view_tag/sheet_music_viewer.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';

class ViewTagScreen extends StatefulWidget {
  const ViewTagScreen({
    required this.viewModel,
    required this.cacheManager,
    required this.nearby,

    super.key,
  });

  final ViewTagViewModel viewModel;
  final CacheManager cacheManager;
  final NearbyNotifier nearby;

  @override
  State<ViewTagScreen> createState() => _ViewTagScreenState();
}

class _ViewTagScreenState extends State<ViewTagScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => _startBroadcast(),
    );
  }

  @override
  void didUpdateWidget(ViewTagScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewModel.tagId != oldWidget.viewModel.tagId) {
      unawaited(_startBroadcast());
    }
  }

  Future<void> _startBroadcast() async {
    await widget.nearby.startBroadcasting(widget.viewModel.tagId);
  }

  @override
  void dispose() {
    unawaited(widget.nearby.stopBroadcasting());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              _favoriteToggle(context),

              _detailsLink(context),
            ],
          ),
          body: switch (widget.viewModel.result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => Center(child: Text(message)),
            Ok(:final value) => switch (value.sheetMusicUrl) {
              null => const SizedBox.shrink(),
              final url => SheetMusicViewer(
                url: url,
                cacheManager: widget.cacheManager,
              ),
            },
          },

          bottomNavigationBar: switch (widget.viewModel.result) {
            Ok(:final value) => _tracksPlayer(context, value),
            _ => null,
          },
        );
      },
    );
  }

  Widget? _tracksPlayer(BuildContext context, BarbershopTag value) {
    if (value.learningTracks.isEmpty) return null;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      padding: const .all(16),
      child: SafeArea(
        child: LearningTrackPlayer(
          tracks: value.learningTracks,
          cacheManager: widget.cacheManager,
        ),
      ),
    );
  }

  Widget _detailsLink(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline_rounded),
      onPressed: () {
        context.go('tag/details?id=${widget.viewModel.tagId}');
      },
    );
  }

  Widget _favoriteToggle(BuildContext context) {
    return switch (widget.viewModel.result) {
      Ok(:final value) => IconButton(
        isSelected: value.isFavorite,
        icon: const Icon(Icons.favorite_border_rounded),
        selectedIcon: const Icon(Icons.favorite_rounded),
        onPressed: () async {
          final result = await ((value.isFavorite)
              ? widget.viewModel.removeFromFavorites()
              : widget.viewModel.addToFavorites());

          if (!context.mounted) return;

          if (result case Failure(:final message)) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        },
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
