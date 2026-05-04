import 'package:flutter/material.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/search/search_view_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required this.viewModel});

  final SearchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return SearchAnchor.bar(
              suggestionsBuilder: (context, controller) {
                return switch (viewModel.result) {
                  Ok(:final value) => value.map((i) => TagListTile(tag: i)),
                  _ => [],
                };
              },
              onSubmitted: viewModel.onQueryUpdated,
              onChanged: viewModel.onQueryUpdated,
            );
          },
        ),
      ),
    );
  }
}

class TagListTile extends StatelessWidget {
  const TagListTile({super.key, required this.tag});

  final BarbershopTag tag;
  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(tag.title), subtitle: Text('#${tag.id}'));
  }
}
