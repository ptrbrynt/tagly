import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaglyIcon extends StatelessWidget {
  const TaglyIcon({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      widthFactor: 1,
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: .circular(16),
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/app-icon-foreground.svg',
              height: size * (40 / 48),
            ),
          ),
        ),
      ),
    );
  }
}
