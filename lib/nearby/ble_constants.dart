import 'package:flutter/foundation.dart';

const kTaglyServiceUuid = 'b73dbd65-5433-46e1-8a33-eebe2af859bb';

Uint8List encodeTagId(int tagId) {
  final bytes = ByteData(4);
  bytes.setInt32(0, tagId, .little);
  return bytes.buffer.asUint8List();
}

int? decodeTagId(Uint8List bytes) {
  if (bytes.length < 4) return null;
  return ByteData.view(bytes.buffer).getInt32(0, .little);
}
