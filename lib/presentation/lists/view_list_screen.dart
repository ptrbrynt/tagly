import 'package:flutter/material.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/lists/view_list_view_model.dart';
import 'package:tagly/presentation/search/search_screen.dart';

class ViewListScreen extends StatelessWidget {
  const ViewListScreen({
    required this.listName,
    required this.viewModel,
    super.key,
  });

  final String listName;
  final ViewListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(listName)),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return switch (viewModel.result) {
            null => const Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => Center(child: Text(message)),
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
