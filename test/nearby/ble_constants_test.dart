import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/nearby/ble_constants.dart';

void main() {
  test('encodeTagId / decodeTagId roundtrip', () {
    for (final id in [0, 1, 255, 1000, 99999, 2147483647]) {
      expect(decodeTagId(encodeTagId(id)), id);
    }
  });

  test('decodeTagId returns null for short buffer', () {
    expect(decodeTagId(Uint8List.fromList([0x01, 0x02])), isNull);
  });
}
