import 'package:freezed_annotation/freezed_annotation.dart';

part 'vertical_bar.freezed.dart';

/// A rectangle in logical pixels from the top-left of the app's view.
@freezed
abstract class ScreenRect with _$ScreenRect {
  const factory({
    required double left,
    required double top,
    required double width,
    required double height,
  }) = _ScreenRect;
}

extension ScreenRectGeometry on ScreenRect {
  double get right => left + width;
  double get bottom => top + height;
}

enum VerticalBarEdge { left, right }

/// The system's vertical bar: a column on one side of the display, below the
/// status bar and camera, where app bar controls belong while it is shown.
@freezed
abstract class VerticalBar with _$VerticalBar {
  const factory({
    required VerticalBarEdge edge,

    /// Where the system places bar controls, centred on the status bar and
    /// camera above it.
    required ScreenRect controls,
  }) = _VerticalBar;
}
