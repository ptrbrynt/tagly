import 'package:sqflite/sqflite.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/domain/tag_list.dart';

class ListsRepository {
  ListsRepository({required Database db}) : _db = db;

  final Database _db;

  Future<Result<List<TagList>>> getLists() async {
    try {
      final lists = await _db.query('lists');

      return .ok(lists.map(TagList.fromJson).toList());
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<void>> createList(String name) async {
    try {
      await _db.insert('lists', {'name': name});
      return const .ok(null);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<void>> deleteList(int id) async {
    try {
      await _db.delete('lists', where: 'id = ?', whereArgs: [id]);
      return const .ok(null);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }

  Future<Result<void>> renameList({
    required int id,
    required String name,
  }) async {
    try {
      await _db.update(
        'lists',
        {'name': name},
        where: 'id = ?',
        whereArgs: [id],
      );
      return const .ok(null);
    } on DatabaseException catch (e) {
      return .failure(e.toString());
    }
  }
}
