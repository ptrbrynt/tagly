import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tagly/domain/vertical_bar.dart';

class VerticalBarRepository extends ChangeNotifier {
  /// [events] emits maps as sent by the native `tagly/vertical_bar` channel.
  new({required Stream<Object?> events}) {
    _subscription = events.listen(
      _onEvent,
      // Platforms without the native channel report an error; treat them as
      // having no vertical bar.
      onError: (Object _) {},
    );
  }

  late final StreamSubscription<Object?> _subscription;

  VerticalBar? _verticalBar;

  /// The system's vertical bar while it is shown, otherwise null.
  VerticalBar? get verticalBar => _verticalBar;

  void _onEvent(Object? event) {
    final verticalBar = switch (event) {
      {'edge': final String edge, 'bar': final Object? bar}
          when edge == 'left' || edge == 'right' =>
        switch (_rect(bar)) {
          final ScreenRect controls => VerticalBar(
            edge: edge == 'left' ? VerticalBarEdge.left : VerticalBarEdge.right,
            controls: controls,
          ),
          null => null,
        },
      _ => null,
    };
    if (verticalBar == _verticalBar) return;
    _verticalBar = verticalBar;
    notifyListeners();
  }

  static ScreenRect? _rect(Object? value) => switch (value) {
    {
      'left': final num left,
      'top': final num top,
      'width': final num width,
      'height': final num height,
    } =>
      ScreenRect(
        left: left.toDouble(),
        top: top.toDouble(),
        width: width.toDouble(),
        height: height.toDouble(),
      ),
    _ => null,
  };

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
