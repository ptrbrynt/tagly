import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tagly/domain/fold.dart';

class FoldRepository extends ChangeNotifier {
  /// [regionEvents] emits lists of `{left, top, width, height, active}` maps,
  /// as sent by the native `tagly/fold_regions` channel.
  new({required Stream<Object?> regionEvents}) {
    _subscription = regionEvents.listen(
      _onRegions,
      // Platforms without the native channel report an error; treat them as
      // having no fold.
      onError: (Object _) {},
    );
  }

  late final StreamSubscription<Object?> _subscription;

  Fold? _fold;

  /// The fold while the device is partly folded, otherwise null.
  Fold? get activeFold => (_fold?.isActive ?? false) ? _fold : null;

  bool get isTabletop => activeFold?.isHorizontal ?? false;

  void _onRegions(Object? event) {
    final folds = [
      for (final region in (event as List<Object?>?) ?? const <Object?>[])
        if (region case {
          'left': final num left,
          'top': final num top,
          'width': final num width,
          'height': final num height,
          'active': final bool isActive,
        })
          Fold(
            left: left.toDouble(),
            top: top.toDouble(),
            width: width.toDouble(),
            height: height.toDouble(),
            isActive: isActive,
          ),
    ];
    final fold =
        folds.where((fold) => fold.isActive).firstOrNull ?? folds.firstOrNull;
    if (fold == _fold) return;
    _fold = fold;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
