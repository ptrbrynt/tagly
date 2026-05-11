import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class LegacyMigrationRepository {
  LegacyMigrationRepository({
    required Database legacyDatabase,
    required Database newDatabase,
  }) : _legacyDatabase = legacyDatabase,
       _newDatabase = newDatabase;

  final Database _legacyDatabase;
  final Database _newDatabase;

  /// Takes data stored in the `my_lists` table of the legacy database
  /// and saves it in the new database.
  Future<void> migrate() async {
    final myListsData = await _legacyDatabase.query('my_lists');

    await _newDatabase.transaction((txn) async {
      for (final listRow in myListsData) {
        final name = listRow['name']! as String;
        final listId = await txn.insert('lists', {'name': name});

        final listTags =
            jsonDecode(listRow['tags']! as String) as List<dynamic>;

        final tagIds = listTags.cast<Map<String, dynamic>>().map(
          (i) => (i['id'] as num).toInt(),
        );

        for (final id in tagIds) {
          await txn.insert('list_tags', {'list_id': listId, 'tag_id': id});
        }
      }
    });

    await _legacyDatabase.delete('my_lists');
  }
}
