import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/nearby/nearby_notifier.dart';
import 'package:tagly/presentation/view_tag/sheet_music_viewer.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';

class ViewTagScreen extends StatelessWidget {
  const ViewTagScreen({
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
        return Scaffold(
          appBar: AppBar(actions: [_broadcastToggle(), _detailsLink(context)]),
          body: switch (viewModel.result) {
            null => Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => Center(child: Text(message)),
            Ok(:final value) => switch (value.sheetMusicUrl) {
              null => SizedBox.shrink(),
              final url => SheetMusicViewer(url: url),
            },
          },
        );
      },
    );
  }

  Widget _detailsLink(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info_outline_rounded),
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
              ? () => nearby.stopBroadcasting()
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
