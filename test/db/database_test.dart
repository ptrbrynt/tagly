import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_db.dart';

void main() {
  group('database', () {
    test('opens successfully', () async {
      final db = await openTestDb();

      assert(db.isOpen, isTrue);

      await db.close();
    });
  });
}
