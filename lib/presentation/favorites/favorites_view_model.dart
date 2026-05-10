import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel({required TagsRepository repository})
    : _repository = repository {
    unawaited(load());
  }

  final TagsRepository _repository;

  Result<List<BarbershopTag>>? _result;
  Result<List<BarbershopTag>>? get result => _result;

  Future<void> load() async {
    _result = await _repository.getFavorites();
    notifyListeners();
  }
}
