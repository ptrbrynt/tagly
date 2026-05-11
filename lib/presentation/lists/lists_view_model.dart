import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tagly/data/lists_repository.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_list.dart';

class ListsViewModel extends ChangeNotifier {
  ListsViewModel({required ListsRepository repository})
    : _repository = repository {
    unawaited(load());
  }

  final ListsRepository _repository;

  Result<List<TagList>>? _result;
  Result<List<TagList>>? get result => _result;

  Future<void> load() async {
    _result = await _repository.getLists();
    notifyListeners();
  }

  Future<Result<void>> createList(String name) =>
      _repository.createList(name).whenComplete(load);

  Future<Result<void>> deleteList(int id) =>
      _repository.deleteList(id).whenComplete(load);
}
