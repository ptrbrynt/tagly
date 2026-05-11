import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tagly/data/lists_repository.dart';
import 'package:tagly/data/settings_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/nearby/nearby_notifier.dart';
import 'package:tagly/presentation/audio_player/learning_track_player.dart';
import 'package:tagly/presentation/lists/add_to_list_button.dart';
import 'package:tagly/presentation/view_tag/sheet_music_viewer.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewTagScreen extends StatefulWidget {
  const ViewTagScreen({
    required this.viewModel,
    required this.listsRepository,
    required this.settingsRepository,
    required this.cacheManager,
    required this.nearby,
    required this.sharePlus,
    super.key,
  });

  final ViewTagViewModel viewModel;
  final ListsRepository listsRepository;
  final SettingsRepository settingsRepository;
  final CacheManager cacheManager;
  final NearbyNotifier nearby;
  final SharePlus sharePlus;

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
    if (widget.settingsRepository.shouldAlwaysBroadcast) {
      await widget.nearby.startBroadcasting(widget.viewModel.tagId);
    }
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
              if (widget.viewModel.result case Ok(:final value)) ...[
                _favoriteToggle(context),
                _tagMenu(value),
              ],
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

  Widget _tagMenu(BarbershopTag tag) {
    return MenuAnchor(
      builder: (context, controller, child) => IconButton(
        icon: const Icon(Icons.more_vert_rounded),
        onPressed: controller.open,
      ),
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.info_outline_rounded),
          onPressed: () {
            context.go('tag/details?id=${tag.id}');
          },
          child: const Text('Tag Details'),
        ),
        AddToListButton(
          listsRepository: widget.listsRepository,
          tagId: widget.viewModel.tagId,
          onListSelected: (listId) async {
            final result = await widget.viewModel.addTagToList(listId);

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(switch (result) {
                  Ok() => 'Tag added to list',
                  Failure(:final message) => message,
                }),
              ),
            );
          },
        ),
        MenuItemButton(
          leadingIcon: Platform.isIOS
              ? const Icon(Icons.ios_share_rounded)
              : const Icon(Icons.share_rounded),
          onPressed: () async {
            await widget.sharePlus.share(
              ShareParams(uri: tag.tagUri, title: tag.title),
            );
          },
          child: const Text('Share'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.open_in_browser_rounded),
          onPressed: () async {
            if (await canLaunchUrl(tag.tagUri)) {
              await launchUrl(tag.tagUri, mode: .externalApplication);
            }
          },
          child: const Text('Open in browser'),
        ),
      ],
    );
  }
}
