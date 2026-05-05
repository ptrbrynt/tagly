import 'package:flutter/foundation.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

class ViewTagViewModel extends ChangeNotifier {
  ViewTagViewModel({required TagsRepository repository, required this.tagId})
    : _repository = repository {
    load();
  }

  final TagsRepository _repository;
  final int tagId;

  Result<BarbershopTag>? _result;
  Result<BarbershopTag>? get result => _result;

  Future<void> load() async {
    _result = await _repository.getTagById(tagId);
    notifyListeners();
  }
}
