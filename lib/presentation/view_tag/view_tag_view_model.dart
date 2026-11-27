import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

class ViewTagViewModel extends ChangeNotifier {
  new({required this._repository, required this.tagId}) {
    _repository.addListener(_reload);
    unawaited(load());
  }

  final TagsRepository _repository;
  final int tagId;

  Result<BarbershopTag>? _result;
  Result<BarbershopTag>? get result => _result;

  Future<void> load() async {
    final result = await _repository.getTagById(tagId);
    if (_isDisposed) return;
    _result = result;
    notifyListeners();
  }

  bool _isDisposed = false;

  void _reload() => unawaited(load());

  Future<Result<void>> addToFavorites() => _repository.addToFavorites(tagId);

  Future<Result<void>> removeFromFavorites() =>
      _repository.removeFromFavorites(tagId);

  Future<Result<void>> addTagToList(int listId) {
    return _repository.addTagToList(tagId: tagId, listId: listId);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _repository.removeListener(_reload);
    super.dispose();
  }
}
