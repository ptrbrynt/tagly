import 'package:flutter/material.dart';

class PositionOriginProvider extends StatelessWidget {
  const PositionOriginProvider({required this.builder, super.key});

  final Widget Function(BuildContext, Rect?) builder;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final box = context.findRenderObject() as RenderBox?;
        return builder(
          context,
          box != null ? (box.localToGlobal(.zero) & box.size) : null,
        );
      },
    );
  }
}
