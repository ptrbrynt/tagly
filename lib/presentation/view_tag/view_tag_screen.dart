import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/nearby/nearby_notifier.dart';
import 'package:tagly/presentation/view_tag/sheet_music_viewer.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';

class ViewTagScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(actions: [_broadcastToggle(), _detailsLink(context)]),
          body: switch (viewModel.result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => Center(child: Text(message)),
            Ok(:final value) => switch (value.sheetMusicUrl) {
              null => const SizedBox.shrink(),
              final url => SheetMusicViewer(
                url: url,
                cacheManager: cacheManager,
              ),
            },
          },
        );
      },
    );
  }

  Widget _detailsLink(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline_rounded),
      onPressed: () {
        context.go('tag/details?id=${viewModel.tagId}');
      },
    );
  }

  Widget _broadcastToggle() {
    return ListenableBuilder(
      listenable: nearby,
      builder: (context, _) {
        return IconButton(
          tooltip: 'Share nearby',
          onPressed: nearby.isBroadcasting
              ? nearby.stopBroadcasting
              : () => nearby.startBroadcasting(viewModel.tagId),
          icon: Icon(
            Icons.cell_tower_rounded,
            color: nearby.isBroadcasting
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
        );
      },
    );
  }
}
