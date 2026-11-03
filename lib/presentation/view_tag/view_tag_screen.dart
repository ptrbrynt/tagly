import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/adaptive/tagly_scaffold.dart';
import 'package:tagly/presentation/audio_player/learning_track_player.dart';
import 'package:tagly/presentation/lists/add_to_list_menu.dart';
import 'package:tagly/presentation/lists/lists_view_model.dart';
import 'package:tagly/presentation/utils/help_sheet.dart';
import 'package:tagly/presentation/utils/tagly_icon.dart';
import 'package:tagly/presentation/view_tag/sheet_music_viewer.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewTagScreen extends StatefulWidget {
  const new({
    required this.tagId,
    required this.tagsRepository,
    required this.listsViewModel,
    required this.cacheManager,
    required this.sharePlus,
    required this.onShowDetails,
    super.key,
  });

  final VoidCallback onShowDetails;
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
      listenable: Listenable.merge([_viewModel, widget.listsViewModel]),
      builder: (context, _) {
        return TaglyScaffold(
          title: '#${widget.tagId}',
          items: switch (_viewModel.result) {
            Ok(:final value) => _barItems(context, value),
            _ => const [],
          },
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
          bottomBar: switch (_viewModel.result) {
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

  List<BarItem> _barItems(BuildContext context, BarbershopTag tag) => [
    BarItem(
      label: tag.isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
      icon: Icons.favorite_border_rounded,
      selectedIcon: Icons.favorite_rounded,
      isSelected: tag.isFavorite,
      priority: .high,
      onPressed: () => _toggleFavorite(context, tag),
    ),
    BarItem(
      label: 'Add to List',
      icon: Icons.playlist_add_rounded,
      group: 1,
      menuChildren: addToListMenuItems(
        lists: switch (widget.listsViewModel.result) {
          Ok(:final value) => value,
          _ => [],
        },
        onListSelected: _addTagToList,
        onCreateListSelected: _createList,
      ),
    ),
    BarItem(
      label: 'Share',
      icon: Platform.isIOS ? Icons.ios_share_rounded : Icons.share_rounded,
      group: 1,
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.explore_rounded),
          onPressed: () => _share(tag.tagUri, tag.title),
          child: const Text('Link to barbershoptags.com'),
        ),
        MenuItemButton(
          leadingIcon: TaglyIcon.inverse(context, size: 24),
          onPressed: () => _share(tag.deepLink, tag.title),
          child: const Text('Tagly Link'),
        ),
        const Divider(),
        MenuItemButton(
          leadingIcon: const Icon(Icons.help_outline_rounded),
          onPressed: () => _showShareHelp(context),
          child: const Text('What do I choose?'),
        ),
      ],
    ),
    BarItem(
      label: 'Tag Details',
      icon: Icons.info_outline_rounded,
      priority: .low,
      group: 2,
      onPressed: widget.onShowDetails,
    ),
    BarItem(
      label: 'Open in Browser',
      icon: Icons.open_in_browser_rounded,
      priority: .low,
      group: 2,
      onPressed: () async {
        if (await canLaunchUrl(tag.tagUri)) {
          await launchUrl(tag.tagUri, mode: .externalApplication);
        }
      },
    ),
  ];

  Future<void> _toggleFavorite(BuildContext context, BarbershopTag tag) async {
    final result = await (tag.isFavorite
        ? _viewModel.removeFromFavorites()
        : _viewModel.addToFavorites());

    if (!context.mounted) return;

    if (result case Failure(:final message)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _share(Uri uri, String title) async {
    final box = context.findRenderObject() as RenderBox?;
    await widget.sharePlus.share(
      ShareParams(
        uri: uri,
        title: title,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(.zero) & box.size,
      ),
    );
  }

  void _showShareHelp(BuildContext context) {
    unawaited(
      HelpSheet.show(
        context: context,
        title: 'Sharing Tags',
        steps: [
          const HelpStep(
            icon: Icons.link,
            title: 'Share with Tagly users',
            description:
                "Tagly Links work great when you know the person you're "
                'sharing with uses Tagly. It will open the tag directly '
                'in the app on their phone.',
          ),
          const HelpStep(
            icon: Icons.explore_rounded,
            title: 'Share barbershoptags.com link',
            description:
                "If you don't know whether the person you're sharing with "
                "uses Tagly, it's best to share the barbershoptags.com link. "
                'It will open the tag in their web browser.',
          ),
          HelpStep(
            icon: Icons.search_rounded,
            title: 'Try searching instead',
            description:
                'Search by ID is a great alternative to link sharing. '
                "You can give someone the Tag ID (for this tag, it's "
                '${widget.tagId}) and they can look for '
                'it themselves in their favorite tag app.',
          ),
        ],
      ),
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    } else if (result case Ok(:final value)) {
      await _addTagToList(value);
    }
  }
}
