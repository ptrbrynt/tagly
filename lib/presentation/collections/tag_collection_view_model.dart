import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_search_query.dart';

class TagCollectionViewModel extends ChangeNotifier {
  TagCollectionViewModel({
    required this.initialQuery,
    required this.repository,
  }) : query = initialQuery {
    unawaited(load());
  }

  final TagSearchQuery initialQuery;

  TagSearchQuery query;
  final TagsRepository repository;

  Result<List<BarbershopTag>>? _result;
  Result<List<BarbershopTag>>? get result => _result;

  Future<void> load() async {
    _result = await repository.searchTags(query);
    notifyListeners();
  }

  void updateQuery(TagSearchQuery newQuery) {
    query = newQuery;
    unawaited(load());
  }
}
