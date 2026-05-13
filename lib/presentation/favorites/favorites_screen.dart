import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/favorites/favorites_view_model.dart';
import 'package:tagly/presentation/utils/dismissible_background.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';
import 'package:tagly/presentation/utils/failure_card.dart';
import 'package:tagly/presentation/utils/help_sheet.dart';
import 'package:tagly/presentation/utils/tag_list_tile.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({required this.viewModel, super.key});

  final FavoritesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return switch (viewModel.result) {
            null => const Center(
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
            Failure(:final message) => FailureCard(
              message: message,
              onRetry: viewModel.load,
            ),
            Ok(:final value) =>
              value.isEmpty
                  ? EmptyStateCard(
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          const SizedBox(height: 16),
                          const Text('No favorites yet'),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            icon: const Icon(Icons.help_outline_rounded),
                            label: const Text(
                              'How do I add tags to favorites?',
                            ),
                            onPressed: () => _showHelp(context),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) =>
                          _listTile(context, value[index]),
                    ),
          };
        },
      ),
    );
  }

  Widget _listTile(BuildContext context, BarbershopTag tag) {
    return Dismissible(
      key: ValueKey(tag.id),
      background: DismissibleBackground.remove(context, .centerLeft),
      secondaryBackground: DismissibleBackground.remove(context, .centerRight),
      onDismissed: (_) => _removeFavorite(context, tag.id),
      child: TagListTile(tag: tag),
    );
  }

  Future<void> _removeFavorite(BuildContext context, int tagId) async {
    final result = await viewModel.removeFromFavorites(tagId);

    if (!context.mounted) return;

    if (result case Failure(:final message)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed #$tagId from Favorites'),
          persist: false,
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await viewModel.addToFavorites(tagId);
            },
          ),
        ),
      );
    }
  }

  void _showHelp(BuildContext context) {
    unawaited(
      HelpSheet.show(
        context: context,
        title: 'How to add Favorites',
        steps: [
          const HelpStep(
            icon: Icons.search_rounded,
            title: 'Open a tag',
            description: 'Find a tag you want to add to Favorites',
          ),
          const HelpStep(
            icon: Icons.favorite_outline_rounded,
            title: 'Tap the Heart',
            description: 'Tap the outlined Heart in the top-right.',
          ),
          const HelpStep(
            icon: Icons.heart_broken_rounded,
            title: 'Tap again to remove',
            description:
                'If a tag is already in your Favorites, '
                'tap the Heart again to remove it.',
          ),
        ],
      ),
    );
  }
}
