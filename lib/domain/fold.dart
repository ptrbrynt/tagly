import 'package:freezed_annotation/freezed_annotation.dart';

part 'fold.freezed.dart';

/// The fold of a foldable display, in logical pixels from the top-left of the
/// app's view. Its frame already includes the clearance interactive content
/// should keep from the curve.
@freezed
abstract class Fold with _$Fold {
  const factory({
    required double left,
    required double top,
    required double width,
    required double height,
    required bool isActive,
  }) = _Fold;
}

extension FoldGeometry on Fold {
  double get bottom => top + height;

  /// Runs across the display rather than down it, as when the device is
  /// propped open on a table.
  bool get isHorizontal => width > height;
}
