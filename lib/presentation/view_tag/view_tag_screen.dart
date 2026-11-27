import 'dart:async';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tagly/data/fold_repository.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/audio_player/learning_track_player.dart';
import 'package:tagly/presentation/lists/add_to_list_button.dart';
import 'package:tagly/presentation/lists/lists_view_model.dart';
import 'package:tagly/presentation/utils/fold_aware_dialogs.dart';
import 'package:tagly/presentation/utils/help_sheet.dart';
import 'package:tagly/presentation/utils/list_detail_layout.dart';
import 'package:tagly/presentation/utils/position_origin_provider.dart';
import 'package:tagly/presentation/utils/tagly_icon.dart';
import 'package:tagly/presentation/utils/vertical_bar_controls.dart';
import 'package:tagly/presentation/view_tag/sheet_music_viewer.dart';
import 'package:tagly/presentation/view_tag/tabletop_column.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewTagScreen extends StatefulWidget {
  const new({
    required this.tagId,
    required this.tagsRepository,
    required this.listsViewModel,
    required this.cacheManager,
    required this.sharePlus,
    required this.foldRepository,
    required this.onShowDetails,
    this.showsBackButton = true,
    super.key,
  });

  final int tagId;
  final TagsRepository tagsRepository;
  final ListsViewModel listsViewModel;
  final CacheManager cacheManager;
  final SharePlus sharePlus;
  final FoldRepository foldRepository;
  final VoidCallback onShowDetails;
  final bool showsBackButton;

  @override
  State<ViewTagScreen> createState() => _ViewTagScreenState();
}

class _ViewTagScreenState extends State<ViewTagScreen> {
  late final ViewTagViewModel _viewModel;
  late final Listenable _changes;

  // Keep the sheet music and the player (and its audio) alive when they move
  // into and out of the tabletop layout.
  final GlobalKey _sheetMusicKey = GlobalKey();
  final GlobalKey _tracksPlayerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _viewModel = ViewTagViewModel(
      repository: widget.tagsRepository,
      tagId: widget.tagId,
    );
    _changes = Listenable.merge([_viewModel, widget.foldRepository]);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _changes,
      builder: (context, _) {
        return VerticalBarScaffold(
          automaticallyImplyLeading: widget.showsBackButton,
          title: Text('#${widget.tagId}'),
          actions: [
            if (_viewModel.result case Ok(:final value)) ...[
              _favoriteToggle(context),
              _tagMenu(context, value),
            ],
          ],
          body: switch (_viewModel.result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => Center(child: Text(message)),
            Ok(:final value) => TabletopColumn(
              fold: widget.foldRepository.activeFold,
              content: _sheetMusic(value),
              controls: value.learningTracks.isEmpty
                  ? null
                  : ({required isTabletop}) =>
                        _tracksPlayer(context, value, isTabletop: isTabletop),
            ),
          },
        );
      },
    );
  }

  Widget _sheetMusic(BarbershopTag value) {
    return switch (value.sheetMusicUrl) {
      null => const SizedBox.shrink(),
      final url => SafeArea(
        top: false,
        bottom: false,
        child: SizedBox.expand(
          child: SheetMusicViewer(
            key: _sheetMusicKey,
            url: url,
            cacheManager: widget.cacheManager,
          ),
        ),
      ),
    };
  }

  Widget _tracksPlayer(
    BuildContext context,
    BarbershopTag value, {
    required bool isTabletop,
  }) {
    final player = Padding(
      padding: isShortWindow(context)
          ? const .symmetric(horizontal: 16, vertical: 4)
          : const .all(16),
      child: LearningTrackPlayer(
        key: _tracksPlayerKey,
        tracks: value.learningTracks,
        cacheManager: widget.cacheManager,
      ),
    );
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: isTabletop ? Center(child: player) : player,
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
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }
        },
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _tagMenu(BuildContext context, BarbershopTag tag) {
    return PositionOriginProvider(
      builder: (context, origin) {
        return MenuAnchor(
          // In the split view this screen sits in a pane with its own
          // overlay. Flutter places menus there by mixing pane coordinates
          // with window ones for the fold, which runs the menu under the
          // vertical bar. The root overlay uses window coordinates throughout.
          useRootOverlay: true,
          builder: (context, controller, child) => IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: controller.open,
          ),
          menuChildren: [
            MenuItemButton(
              leadingIcon: const Icon(Icons.info_outline_rounded),
              onPressed: widget.onShowDetails,
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
            SubmenuButton(
              menuChildren: [
                MenuItemButton(
                  leadingIcon: const Icon(Icons.explore_rounded),
                  onPressed: () async {
                    await widget.sharePlus.share(
                      ShareParams(
                        uri: tag.tagUri,
                        title: tag.title,
                        sharePositionOrigin: origin(),
                      ),
                    );
                  },
                  child: const Text('Link to barbershoptags.com'),
                ),
                MenuItemButton(
                  leadingIcon: TaglyIcon.inverse(context, size: 24),
                  onPressed: () async {
                    await widget.sharePlus.share(
                      ShareParams(
                        uri: tag.deepLink,
                        title: tag.title,
                        sharePositionOrigin: origin(),
                      ),
                    );
                  },
                  child: const Text('Tagly Link'),
                ),
                const Divider(),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.help_outline_rounded),
                  onPressed: () {
                    _showShareHelp(context);
                  },
                  child: const Text('What do I choose?'),
                ),
              ],
              leadingIcon: Platform.isIOS
                  ? const Icon(Icons.ios_share_rounded)
                  : const Icon(Icons.share_rounded),
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
      },
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
    final listName = await showTextPromptDialog(
      context: context,
      title: 'New List',
      hintText: 'Awesome Tags',
      textCapitalization: .words,
    );
    if (listName == null || !mounted) return;

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
