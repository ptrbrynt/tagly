import 'dart:math' as math;
import 'dart:ui';

import 'package:material_ui/material_ui.dart';

enum PaneArrangement {
  /// Divides the area between the panes: side by side when wider than tall,
  /// stacked otherwise.
  split,

  /// Layers the primary pane over the secondary, moving them to opposite
  /// sides of the fold when the display is partially folded.
  overlay,
}

/// A layout container for a primary and a secondary view, modelled on
/// Apple's arrangement views. It only lays out content: keep navigation
/// outside it.
///
/// Display features are read from [MediaQuery] in window coordinates, so
/// place it where its origin is the window's origin.
class TwoPane extends StatelessWidget {
  const new({
    required this.primary,
    required this.secondary,
    this.arrangement = .split,
    this.allowedAxes = const {Axis.horizontal, Axis.vertical},
    this.primaryFraction = 0.4,
    this.minPrimaryExtent = 280,
    this.minSecondaryExtent = 320,
    this.showsSecondary = true,
    super.key,
  }) : assert(allowedAxes.length > 0, 'Allow at least one axis');

  final Widget primary;
  final Widget secondary;
  final PaneArrangement arrangement;
  final Set<Axis> allowedAxes;
  final double primaryFraction;
  final double minPrimaryExtent;
  final double minSecondaryExtent;

  /// Collapses the secondary view in an overlay arrangement.
  final bool showsSecondary;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final preferred = size.width >= size.height
            ? Axis.horizontal
            : Axis.vertical;
        final axis = allowedAxes.contains(preferred)
            ? preferred
            : allowedAxes.first;
        final fold = _foldAcross(axis, size, mediaQuery.displayFeatures);

        if (arrangement == .overlay && fold == null) {
          return Stack(
            fit: .expand,
            children: [if (showsSecondary) secondary, primary],
          );
        }
        if (arrangement == .overlay && !showsSecondary) return primary;

        final total = axis == .horizontal ? size.width : size.height;
        final (primaryExtent, gap) = switch (fold) {
          final fold? =>
            axis == .horizontal
                ? (fold.left, fold.width)
                : (fold.top, fold.height),
          null => (
            (total * primaryFraction)
                .clamp(
                  math.min(minPrimaryExtent, total),
                  math.max(0, total - minSecondaryExtent),
                )
                .toDouble(),
            0.0,
          ),
        };
        final secondaryStart = primaryExtent + gap;

        final primaryRect = axis == .horizontal
            ? Rect.fromLTWH(0, 0, primaryExtent, size.height)
            : Rect.fromLTWH(0, 0, size.width, primaryExtent);
        final secondaryRect = axis == .horizontal
            ? Rect.fromLTRB(secondaryStart, 0, size.width, size.height)
            : Rect.fromLTRB(0, secondaryStart, size.width, size.height);

        return Directionality(
          textDirection: .ltr,
          child: Stack(
            children: [
              _pane(context, mediaQuery, primaryRect, axis, primary),
              if (fold == null)
                Positioned.fromRect(
                  rect: axis == .horizontal
                      ? Rect.fromLTWH(primaryExtent, 0, 1, size.height)
                      : Rect.fromLTWH(0, primaryExtent, size.width, 1),
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              _pane(context, mediaQuery, secondaryRect, axis, secondary),
            ],
          ),
        );
      },
    );
  }

  Widget _pane(
    BuildContext context,
    MediaQueryData mediaQuery,
    Rect rect,
    Axis axis,
    Widget child,
  ) {
    final isFirst = rect.topLeft == Offset.zero;
    final padding = mediaQuery.padding;
    EdgeInsets inner(EdgeInsets insets) => switch ((axis, isFirst)) {
      (.horizontal, true) => insets.copyWith(right: 0),
      (.horizontal, false) => insets.copyWith(left: 0),
      (.vertical, true) => insets.copyWith(bottom: 0),
      (.vertical, false) => insets.copyWith(top: 0),
    };
    final edges = PaneEdges.maybeOf(context);
    return Positioned.fromRect(
      rect: rect,
      child: PaneEdges(
        left: (edges?.left ?? true) && (axis == .vertical || isFirst),
        right: (edges?.right ?? true) && (axis == .vertical || !isFirst),
        child: Directionality(
          textDirection: Directionality.of(context),
          child: MediaQuery(
            data: mediaQuery.copyWith(
              padding: inner(padding),
              viewPadding: inner(mediaQuery.viewPadding),
              displayFeatures: [
                for (final feature in mediaQuery.displayFeatures)
                  if (feature.bounds.overlaps(rect))
                    DisplayFeature(
                      bounds: feature.bounds
                          .intersect(rect)
                          .shift(-rect.topLeft),
                      type: feature.type,
                      state: feature.state,
                    ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  /// A fold that runs the full length of the area, perpendicular to [axis].
  static Rect? _foldAcross(
    Axis axis,
    Size size,
    List<DisplayFeature> features,
  ) {
    for (final feature in features) {
      if (feature.type == .cutout) continue;
      final bounds = feature.bounds;
      final spans = axis == .horizontal
          ? bounds.top <= 0 && bounds.bottom >= size.height
          : bounds.left <= 0 && bounds.right >= size.width;
      final inside = axis == .horizontal
          ? bounds.left > 0 && bounds.right < size.width
          : bounds.top > 0 && bounds.bottom < size.height;
      if (spans && inside) return bounds;
    }
    return null;
  }
}

/// Whether a layout has room for one extra level of hierarchy: regular
/// width, and tall enough that it isn't a phone in landscape.
bool isRegularLayout(Size size) => size.width >= 600 && size.height >= 480;

/// Which physical edges of the window a pane reaches. Vertical bars belong
/// to the pane on the bar's edge; other panes keep their controls above them.
class PaneEdges extends InheritedWidget {
  const new({
    required this.left,
    required this.right,
    required super.child,
    super.key,
  });

  final bool left;
  final bool right;

  static PaneEdges? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PaneEdges>();

  @override
  bool updateShouldNotify(PaneEdges oldWidget) =>
      left != oldWidget.left || right != oldWidget.right;
}
