import 'package:material_ui/material_ui.dart';

class PositionOriginProvider extends StatelessWidget {
  const new({required this.builder, super.key});

  final Widget Function(BuildContext, Rect? Function() origin) builder;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => builder(context, () => _originOf(context)),
    );
  }

  static Rect? _originOf(BuildContext context) {
    if (!context.mounted) return null;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return null;
    return box.localToGlobal(.zero) & box.size;
  }
}
