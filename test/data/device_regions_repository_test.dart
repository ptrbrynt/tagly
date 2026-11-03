import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/data/device_regions_repository.dart';
import 'package:tagly/domain/device_regions.dart';

void main() {
  test('parses snapshots from the native bridge', () async {
    final events = StreamController<Object?>();
    final repository = DeviceRegionsRepository(events: events.stream);
    addTearDown(repository.dispose);

    events.add(<Object?, Object?>{
      'barSide': 'right',
      'hinge': {'status': 'partiallyOpen', 'angle': 110.0},
      'regions': [
        {
          'kind': 'division',
          'left': 460.0,
          'top': 0.0,
          'width': 12.0,
          'height': 678.0,
        },
      ],
    });
    await pumpEventQueue();

    expect(
      repository.regions,
      const DeviceRegions(
        barSide: .right,
        hinge: Hinge(status: .partiallyOpen, angle: 110),
        regions: [
          ReservedRegion(
            kind: .division,
            left: 460,
            top: 0,
            width: 12,
            height: 678,
          ),
        ],
      ),
    );
  });

  test('a missing bridge leaves nothing reported', () async {
    final events = StreamController<Object?>();
    final repository = DeviceRegionsRepository(events: events.stream);
    addTearDown(repository.dispose);

    events.addError(MissingPluginException());
    await pumpEventQueue();

    expect(repository.regions, const DeviceRegions());
  });

  test('notifies only when the regions change', () async {
    final events = StreamController<Object?>();
    final repository = DeviceRegionsRepository(events: events.stream);
    addTearDown(repository.dispose);
    var notifications = 0;
    repository.addListener(() => notifications++);

    final snapshot = <Object?, Object?>{
      'barSide': 'left',
      'hinge': null,
      'regions': <Object?>[],
    };
    events
      ..add(snapshot)
      ..add(snapshot);
    await pumpEventQueue();

    expect(notifications, 1);
  });
}
