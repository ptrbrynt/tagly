import 'package:mocktail/mocktail.dart';
import 'package:tagly/nearby/tag_broadcaster.dart';

class FakeTagBroadcaster extends Fake implements TagBroadcaster {
  int? _advertisedId;

  @override
  bool get isAdvertising => _advertisedId != null;

  @override
  Future<bool> isSupported() => Future.value(true);

  @override
  Future<void> startBroadcast(int tagId) async {
    _advertisedId = tagId;
  }

  @override
  Future<void> stopBroadcast() async {
    _advertisedId = null;
  }
}
