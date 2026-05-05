import 'package:flutter/material.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.repository});

  final TagsRepository repository;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // The query currently being searched for. If null, there is no pending
  // request.
  String? _searchingWithQuery;

  // The most recent options received from the API.
  late Iterable<Widget> _lastOptions = <Widget>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SearchAnchor.bar(
          suggestionsBuilder: (context, controller) async {
            _searchingWithQuery = controller.text;
            final result = await widget.repository.searchTags(
              _searchingWithQuery!,
            );

            // If another search happened after this one, throw away these options.
            // Use the previous options instead and wait for the newer request to
            // finish.
            if (_searchingWithQuery != controller.text) {
              return _lastOptions;
            }

            _lastOptions = switch (result) {
              Failure() => [],
              Ok(:final value) => [
                for (final tag in value) TagListTile(tag: tag),
              ],
            };

            return _lastOptions;
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
