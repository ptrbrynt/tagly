import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/audio_player/learning_track_player.dart';
import 'package:tagly/presentation/lists/add_to_list_button.dart';
import 'package:tagly/presentation/lists/lists_view_model.dart';
import 'package:tagly/presentation/view_tag/sheet_music_viewer.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewTagScreen extends StatefulWidget {
  const ViewTagScreen({
    required this.tagId,
    required this.tagsRepository,
    required this.listsViewModel,
    required this.cacheManager,
    required this.sharePlus,
    super.key,
  });

  final int tagId;
  final TagsRepository tagsRepository;
  final ListsViewModel listsViewModel;
  final CacheManager cacheManager;
  final SharePlus sharePlus;

  @override
  State<ViewTagScreen> createState() => _ViewTagScreenState();
}

class _ViewTagScreenState extends State<ViewTagScreen> {
  late final ViewTagViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ViewTagViewModel(
      repository: widget.tagsRepository,
      tagId: widget.tagId,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('#${widget.tagId}'),
            actions: [
              if (_viewModel.result case Ok(:final value)) ...[
                _favoriteToggle(context),
                _tagMenu(context, value),
              ],
            ],
          ),
          body: switch (_viewModel.result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => Center(child: Text(message)),
            Ok(:final value) => switch (value.sheetMusicUrl) {
              null => const SizedBox.shrink(),
              final url => SizedBox.expand(
                child: SheetMusicViewer(
                  url: url,
                  cacheManager: widget.cacheManager,
                ),
              ),
            },
          },
          bottomNavigationBar: switch (_viewModel.result) {
            Ok(:final value) => _tracksPlayer(context, value),
            _ => null,
          },
        );
      },
    );
  }

  Widget? _tracksPlayer(BuildContext context, BarbershopTag value) {
    if (value.learningTracks.isEmpty) return null;
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: SafeArea(
        child: Padding(
          padding: const .all(16),
          child: LearningTrackPlayer(
            tracks: value.learningTracks,
            cacheManager: widget.cacheManager,
          ),
        ),
      ),
    );
  }

  Widget _favoriteToggle(BuildContext context) {
    return switch (_viewModel.result) {
      Ok(:final value) => IconButton(
        isSelected: value.isFavorite,
        icon: const Icon(Icons.favorite_border_rounded),
        selectedIcon: const Icon(Icons.favorite_rounded),
        onPressed: () async {
          final result = await ((value.isFavorite)
              ? _viewModel.removeFromFavorites()
              : _viewModel.addToFavorites());

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

  Widget _tagMenu(BuildContext context, BarbershopTag tag) {
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
        ListenableBuilder(
          listenable: widget.listsViewModel,
          builder: (context, _) {
            return AddToListButton(
              lists: switch (widget.listsViewModel.result) {
                Ok(:final value) => value,
                _ => [],
              },
              onListSelected: _addTagToList,
              onCreateListSelected: _createList,
              tagId: widget.tagId,
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

  Future<void> _addTagToList(int listId) async {
    final result = await _viewModel.addTagToList(listId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          Ok() => 'Tag added to list',
          Failure(:final message) => message,
        }),
      ),
    );
  }

  Future<void> _createList() async {
    final promptResult = await showTextInputDialog(
      context: context,
      title: 'New List',
      textFields: [
        const DialogTextField(
          hintText: 'Awesome Tags',
          textCapitalization: .words,
        ),
      ],
    );
    if (promptResult == null || promptResult.isEmpty) return;

    final listName = promptResult.first;

    final result = await widget.listsViewModel.createList(listName);

    if (result case Failure(:final message)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    } else if (result case Ok(:final value)) {
      await _addTagToList(value);
    }
  }
}
