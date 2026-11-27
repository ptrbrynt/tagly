import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

class ViewTagViewModel extends ChangeNotifier {
  new({required this._repository, required this.tagId}) {
    unawaited(load());
  }

  final TagsRepository _repository;
  final int tagId;

  Result<BarbershopTag>? _result;
  Result<BarbershopTag>? get result => _result;

  Future<void> load() async {
    _result = await _repository.getTagById(tagId);
    notifyListeners();
  }

  Future<Result<void>> addToFavorites() {
    return _repository.addToFavorites(tagId).whenComplete(load);
  }

  Future<Result<void>> removeFromFavorites() {
    return _repository.removeFromFavorites(tagId).whenComplete(load);
  }

  Future<Result<void>> addTagToList(int listId) {
    return _repository.addTagToList(tagId: tagId, listId: listId);
  }
}
