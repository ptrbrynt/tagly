import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

class ViewListViewModel extends ChangeNotifier {
  new({required this.listId, required this._repository}) {
    _repository.addListener(_reload);
    unawaited(load());
  }

  final int listId;
  final TagsRepository _repository;

  Result<List<BarbershopTag>>? _result;
  Result<List<BarbershopTag>>? get result => _result;

  Future<void> load() async {
    final result = await _repository.getTagsForList(listId);
    if (_isDisposed) return;
    _result = result;
    notifyListeners();
  }

  bool _isDisposed = false;

  void _reload() => unawaited(load());

  Future<Result<void>> addTagToList(int tagId) =>
      _repository.addTagToList(tagId: tagId, listId: listId);

  Future<Result<void>> removeTagFromList(int tagId) =>
      _repository.removeTagFromList(tagId: tagId, listId: listId);

  @override
  void dispose() {
    _isDisposed = true;
    _repository.removeListener(_reload);
    super.dispose();
  }
}
