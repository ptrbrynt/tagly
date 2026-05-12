import 'package:flutter/material.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/collections/tag_collection_view_model.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';
import 'package:tagly/presentation/utils/failure_card.dart';
import 'package:tagly/presentation/utils/tag_list_tile.dart';

class TagCollectionScreen extends StatelessWidget {
  const TagCollectionScreen({
    required this.title,
    required this.viewModel,
    super.key,
  });

  final String title;
  final TagCollectionViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return switch (viewModel.result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => FailureCard(
              message: message,
              onRetry: viewModel.load,
            ),
            Ok(value: []) => const EmptyStateCard(child: Text('No results')),
            Ok(:final value) => ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) => TagListTile(tag: value[index]),
            ),
          };
        },
      ),
    );
  }
}
