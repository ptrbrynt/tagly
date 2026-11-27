import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoAlertDialog, CupertinoDialogAction, CupertinoTextField;
import 'package:material_ui/material_ui.dart';
import 'package:tagly/presentation/utils/fold_display_feature.dart';

/// Asks the user to confirm an action, on the same side of a fold as the
/// app's sheets. Returns whether they confirmed.
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'OK',
  bool isDestructive = false,
}) async {
  final confirmed = await showAdaptiveDialog<bool>(
    context: context,
    anchorPoint: foldAwareAnchor(context),
    builder: (context) {
      final cancel = _action(
        context,
        label: 'Cancel',
        onPressed: () => Navigator.pop(context, false),
      );
      final confirm = _action(
        context,
        label: confirmLabel,
        isDefault: !isDestructive,
        isDestructive: isDestructive,
        onPressed: () => Navigator.pop(context, true),
      );
      return _isCupertino(context)
          ? CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [cancel, confirm],
            )
          : AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [cancel, confirm],
            );
    },
  );
  return confirmed ?? false;
}

/// Asks the user for a line of text, on the trailing side of a book fold or
/// above a tabletop fold, clear of the keyboard. Returns the trimmed text,
/// or null if they cancelled or left it empty.
Future<String?> showTextPromptDialog({
  required BuildContext context,
  required String title,
  String? hintText,
  TextCapitalization textCapitalization = TextCapitalization.none,
  String confirmLabel = 'OK',
}) async {
  final text = await showAdaptiveDialog<String>(
    context: context,
    anchorPoint: foldAwareAnchor(context, isAboveKeyboard: true),
    builder: (context) => _TextPromptDialog(
      title: title,
      hintText: hintText,
      textCapitalization: textCapitalization,
      confirmLabel: confirmLabel,
    ),
  );
  final trimmed = text?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}

class _TextPromptDialog extends StatefulWidget {
  const new({
    required this.title,
    required this.hintText,
    required this.textCapitalization,
    required this.confirmLabel,
  });

  final String title;
  final String? hintText;
  final TextCapitalization textCapitalization;
  final String confirmLabel;

  @override
  State<_TextPromptDialog> createState() => _TextPromptDialogState();
}

class _TextPromptDialogState extends State<_TextPromptDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(context, _controller.text);

  @override
  Widget build(BuildContext context) {
    final cancel = _action(
      context,
      label: 'Cancel',
      onPressed: () => Navigator.pop(context),
    );
    final confirm = _action(
      context,
      label: widget.confirmLabel,
      isDefault: true,
      onPressed: _submit,
    );
    if (_isCupertino(context)) {
      return CupertinoAlertDialog(
        title: Text(widget.title),
        content: Padding(
          padding: const .only(top: 12),
          child: CupertinoTextField(
            controller: _controller,
            placeholder: widget.hintText,
            textCapitalization: widget.textCapitalization,
            autofocus: true,
            onSubmitted: (_) => _submit(),
          ),
        ),
        actions: [cancel, confirm],
      );
    }
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: widget.hintText),
        textCapitalization: widget.textCapitalization,
        autofocus: true,
        onSubmitted: (_) => _submit(),
      ),
      actions: [cancel, confirm],
    );
  }
}

bool _isCupertino(BuildContext context) => switch (Theme.of(context).platform) {
  TargetPlatform.iOS || TargetPlatform.macOS => true,
  _ => false,
};

Widget _action(
  BuildContext context, {
  required String label,
  required VoidCallback onPressed,
  bool isDefault = false,
  bool isDestructive = false,
}) {
  if (_isCupertino(context)) {
    return CupertinoDialogAction(
      isDefaultAction: isDefault,
      isDestructiveAction: isDestructive,
      onPressed: onPressed,
      child: Text(label),
    );
  }
  return TextButton(
    style: isDestructive
        ? TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          )
        : null,
    onPressed: onPressed,
    child: Text(label),
  );
}
