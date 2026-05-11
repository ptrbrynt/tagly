import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

class ViewListViewModel extends ChangeNotifier {
  ViewListViewModel({required this.listId, required TagsRepository repository})
    : _repository = repository {
    unawaited(load());
  }

  final int listId;
  final TagsRepository _repository;

  Result<List<BarbershopTag>>? _result;
  Result<List<BarbershopTag>>? get result => _result;

  Future<void> load() async {
    _result = await _repository.getTagsForList(listId);
    notifyListeners();
  }
}
