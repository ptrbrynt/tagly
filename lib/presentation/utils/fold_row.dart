import 'dart:ui' show DisplayFeatureState;

import 'package:material_ui/material_ui.dart';

/// Lays out [start] and [end] side by side with [gap] between them. Normally
/// they share the width equally around a gap of [gapWidth]. While a vertical
/// fold crosses this row, as when the device is folded like a book, the gap
/// widens to cover the fold so each side ends at its edge and nothing sits in
/// the curve.
class FoldRow extends StatefulWidget {
  const new({
    required this.start,
    required this.end,
    required this.gap,
    this.gapWidth = 0,
    this.crossAxisAlignment = .stretch,
    super.key,
  });

  final Widget start;
  final Widget end;
  final Widget Function(double width) gap;
  final double gapWidth;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<FoldRow> createState() => _FoldRowState();
}

class _FoldRowState extends State<FoldRow> {
  Offset? _origin;

  @override
  Widget build(BuildContext context) {
    final fold = _verticalFold(context);
    if (fold != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureOrigin());
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final (startWidth, gapWidth) =
            _aroundFold(fold, width) ??
            ((width - widget.gapWidth) / 2, widget.gapWidth);
        // The same widgets in every case, so both sides keep their state as
        // the device folds and unfolds.
        return Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: startWidth, child: widget.start),
            widget.gap(gapWidth),
            Expanded(child: widget.end),
          ],
        );
      },
    );
  }

  Rect? _verticalFold(BuildContext context) {
    for (final feature in MediaQuery.displayFeaturesOf(context)) {
      final bounds = feature.bounds;
      if (feature.state == DisplayFeatureState.postureHalfOpened &&
          bounds.height > bounds.width) {
        return bounds;
      }
    }
    return null;
  }

  (double, double)? _aroundFold(Rect? fold, double width) {
    final origin = _origin;
    if (fold == null || origin == null) return null;
    final left = fold.left - origin.dx;
    final right = fold.right - origin.dx;
    if (left <= 0 || right >= width) return null;
    return (left, right - left);
  }

  void _measureOrigin() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final origin = box.localToGlobal(Offset.zero);
    if (origin != _origin) setState(() => _origin = origin);
  }
}
