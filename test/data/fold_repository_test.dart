import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/data/fold_repository.dart';
import 'package:tagly/domain/fold.dart';

Map<String, Object> _region({
  double left = 0,
  double top = 460,
  double width = 669,
  double height = 40,
  bool active = true,
}) => {
  'left': left,
  'top': top,
  'width': width,
  'height': height,
  'active': active,
};

void main() {
  group('FoldRepository', () {
    late StreamController<Object?> events;
    late FoldRepository repository;

    setUp(() {
      events = StreamController<Object?>();
      repository = FoldRepository(regionEvents: events.stream);
    });

    tearDown(() async {
      repository.dispose();
      await events.close();
    });

    Future<void> emit(Object? event) async {
      events.add(event);
      await pumpEventQueue();
    }

    test('has no fold before any regions arrive', () {
      expect(repository.activeFold, isNull);
      expect(repository.isTabletop, isFalse);
    });

    test('reports an active horizontal fold as tabletop', () async {
      await emit([_region()]);

      expect(
        repository.activeFold,
        const Fold(left: 0, top: 460, width: 669, height: 40, isActive: true),
      );
      expect(repository.isTabletop, isTrue);
    });

    test('reports an active vertical fold, but not as tabletop', () async {
      await emit([_region(left: 455, top: 0, width: 40, height: 669)]);

      expect(repository.activeFold, isNotNull);
      expect(repository.isTabletop, isFalse);
    });

    test('has no active fold while the region is inactive', () async {
      await emit([_region(active: false)]);

      expect(repository.activeFold, isNull);
    });

    test('prefers the active region when several arrive', () async {
      await emit([_region(active: false, top: 10), _region(top: 460)]);

      expect(repository.activeFold?.top, 460);
    });

    test('notifies only when the fold changes', () async {
      var notifications = 0;
      repository.addListener(() => notifications++);

      await emit([_region()]);
      await emit([_region()]);
      await emit([_region(active: false)]);

      expect(notifications, 2);
    });

    test('treats a stream error as no fold', () async {
      events.addError(Exception('No native channel'));
      await pumpEventQueue();

      expect(repository.activeFold, isNull);
    });
  });
}
