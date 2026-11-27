import 'package:material_ui/material_ui.dart';

class DismissibleBackground extends StatelessWidget {
  const new({
    required this.iconAlignment,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    super.key,
  });

  new deleteForever(BuildContext context, this.iconAlignment, {super.key})
    : backgroundColor = Theme.of(context).colorScheme.error,
      foregroundColor = Theme.of(context).colorScheme.onError,
      icon = Icons.delete_forever_rounded;

  new remove(BuildContext context, this.iconAlignment, {super.key})
    : backgroundColor = Theme.of(context).colorScheme.tertiaryContainer,
      foregroundColor = Theme.of(context).colorScheme.onTertiaryContainer,
      icon = Icons.remove_rounded;

  final Alignment iconAlignment;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const .symmetric(horizontal: 16),
      child: Align(
        alignment: iconAlignment,
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
      ),
    );
  }
}
