import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:material_ui/material_ui.dart';
import 'package:tagly/domain/fold.dart';

/// Reports an active [fold] to Flutter as a display feature, which Flutter
/// only populates on Android. Dialogs, bottom sheets and menus then lay
/// themselves out on one side of the fold rather than across it.
class FoldDisplayFeature extends StatelessWidget {
  const new({required this.fold, required this.child, super.key});

  final Fold? fold;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fold = this.fold;
    if (fold == null || !fold.isActive) return child;
    final data = MediaQuery.of(context);
    return MediaQuery(
      data: data.copyWith(
        displayFeatures: [
          ...data.displayFeatures,
          DisplayFeature(
            bounds: Rect.fromLTWH(fold.left, fold.top, fold.width, fold.height),
            type: DisplayFeatureType.fold,
            state: DisplayFeatureState.postureHalfOpened,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Where a sheet or dialog should go when a fold divides the window: the
/// trailing page of a book, or the base of a device propped on a table, where
/// controls are steadiest to tap. Anything that brings up the keyboard goes
/// above a tabletop fold instead, since the keyboard covers the base.
Offset foldAwareAnchor(BuildContext context, {bool isAboveKeyboard = false}) {
  final size = MediaQuery.sizeOf(context);
  final y = isAboveKeyboard ? 0.0 : size.height;
  return switch (Directionality.of(context)) {
    TextDirection.ltr => Offset(size.width, y),
    TextDirection.rtl => Offset(0, y),
  };
}
