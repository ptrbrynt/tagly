import 'package:flutter/foundation.dart';
import 'package:tagly/data/tags_repository.dart';
import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/result.dart';

class SearchViewModel extends ChangeNotifier {
  SearchViewModel({required TagsRepository repository})
    : _repository = repository;
  final TagsRepository _repository;

  Result<List<BarbershopTag>>? _result;
  Result<List<BarbershopTag>>? get result => _result;

  Future<void> onQueryUpdated(String query) async {
    _result = await _repository.searchTags(query);
    notifyListeners();
  }
}
