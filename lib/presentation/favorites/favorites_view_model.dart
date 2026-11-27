import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

class FavoritesViewModel extends ChangeNotifier {
  new({required this._repository}) {
    _repository.addListener(_reload);
    unawaited(load());
  }

  final TagsRepository _repository;

  Result<List<BarbershopTag>>? _result;
  Result<List<BarbershopTag>>? get result => _result;

  Future<void> load() async {
    final result = await _repository.getFavorites();
    if (_isDisposed) return;
    _result = result;
    notifyListeners();
  }

  bool _isDisposed = false;

  void _reload() => unawaited(load());

  Future<Result<void>> addToFavorites(int tagId) =>
      _repository.addToFavorites(tagId);

  Future<Result<void>> removeFromFavorites(int tagId) =>
      _repository.removeFromFavorites(tagId);

  @override
  void dispose() {
    _isDisposed = true;
    _repository.removeListener(_reload);
    super.dispose();
  }
}
