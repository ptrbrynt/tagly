import 'package:material_ui/material_ui.dart';
import 'package:tagly/domain/fold.dart';

/// Lays out [content] above [controls]. While a horizontal [fold] crosses this
/// widget, as when the device is propped open on a table, [content] fills the
/// region above the fold and [controls] the stable region below it, so nothing
/// sits in the curve.
class TabletopColumn extends StatefulWidget {
  const new({
    required this.fold,
    required this.content,
    required this.controls,
    super.key,
  });

  final Fold? fold;
  final Widget content;
  final Widget Function({required bool isTabletop})? controls;

  @override
  State<TabletopColumn> createState() => _TabletopColumnState();
}

class _TabletopColumnState extends State<TabletopColumn> {
  Offset? _origin;

  @override
  Widget build(BuildContext context) {
    if (widget.fold != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureOrigin());
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final controls = widget.controls;
        final split = _localFold(constraints.maxHeight);
        if (controls == null || split == null) {
          return Column(
            crossAxisAlignment: .stretch,
            children: [
              Expanded(child: widget.content),
              ?controls?.call(isTabletop: false),
            ],
          );
        }
        final (top, bottom) = split;
        return Column(
          crossAxisAlignment: .stretch,
          children: [
            SizedBox(height: top, child: widget.content),
            SizedBox(height: bottom - top),
            Expanded(child: controls(isTabletop: true)),
          ],
        );
      },
    );
  }

  (double, double)? _localFold(double height) {
    final fold = widget.fold;
    final origin = _origin;
    if (fold == null || !fold.isHorizontal || origin == null) return null;
    final top = fold.top - origin.dy;
    final bottom = fold.bottom - origin.dy;
    if (top <= 0 || bottom >= height) return null;
    return (top, bottom);
  }

  void _measureOrigin() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final origin = box.localToGlobal(Offset.zero);
    if (origin != _origin) setState(() => _origin = origin);
  }
}
