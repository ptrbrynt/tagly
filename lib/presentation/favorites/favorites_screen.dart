import 'package:flutter/material.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/favorites/favorites_view_model.dart';
import 'package:tagly/presentation/search/search_screen.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';
import 'package:tagly/presentation/utils/failure_card.dart';

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
                  ? const EmptyStateCard(child: Text('No favorites added yet'))
                  : ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) =>
                          TagListTile(tag: value[index]),
                    ),
          };
        },
      ),
    );
  }
}
