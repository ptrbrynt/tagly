import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/data/vertical_bar_repository.dart';
import 'package:tagly/domain/vertical_bar.dart';

void main() {
  group('VerticalBarRepository', () {
    late StreamController<Object?> events;
    late VerticalBarRepository repository;

    setUp(() {
      events = StreamController<Object?>();
      repository = VerticalBarRepository(events: events.stream);
    });

    tearDown(() async {
      repository.dispose();
      await events.close();
    });

    Future<void> emit(Object? event) async {
      events.add(event);
      await pumpEventQueue();
    }

    test('reports the bar column on the right edge', () async {
      await emit({
        'edge': 'right',
        'bar': {'left': 879, 'top': 124, 'width': 48, 'height': 511},
      });

      expect(
        repository.verticalBar,
        const VerticalBar(
          edge: VerticalBarEdge.right,
          controls: ScreenRect(left: 879, top: 124, width: 48, height: 511),
        ),
      );
    });

    test('reports the corner-adapted safe area', () async {
      // Measured on the closed display in landscape.
      await emit({
        'edge': 'right',
        'bar': {'left': 606, 'top': 24, 'width': 48, 'height': 408},
        'cornerSafeArea': {'left': 17.3, 'top': 0, 'right': 84, 'bottom': 34},
      });

      expect(
        repository.verticalBar?.cornerSafeArea,
        const ScreenInsets(left: 17.3, right: 84, bottom: 34),
      );
    });

    test('reports the bar column on the left edge', () async {
      await emit({
        'edge': 'left',
        'bar': {'left': 24, 'top': 0, 'width': 48, 'height': 384},
      });

      expect(repository.verticalBar?.edge, VerticalBarEdge.left);
    });

    test('has no bar when the system shows none', () async {
      await emit({
        'edge': 'right',
        'bar': {'left': 879, 'top': 124, 'width': 48, 'height': 511},
      });
      await emit({'edge': 'none'});

      expect(repository.verticalBar, isNull);
    });

    test('has no bar when an edge comes without a column', () async {
      await emit({'edge': 'right'});

      expect(repository.verticalBar, isNull);
    });

    test('treats a stream error as no bar', () async {
      events.addError(Exception('No native channel'));
      await pumpEventQueue();

      expect(repository.verticalBar, isNull);
    });
  });
}
