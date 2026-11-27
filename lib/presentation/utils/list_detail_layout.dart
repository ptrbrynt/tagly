import 'package:material_ui/material_ui.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';

const listDetailMinWidth = 600.0;

bool showsListAndDetail(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= listDetailMinWidth;

class ListDetailLayout extends StatelessWidget {
  const new({required this.list, required this.detail, super.key});

  final Widget list;
  final Widget detail;

  @override
  Widget build(BuildContext context) {
    if (!showsListAndDetail(context)) return detail;
    // Each pane gets its own messenger so a snackbar appears only in the pane
    // that raised it, instead of being duplicated in both. Each pane also
    // drops the inset on the edge it shares with the other pane.
    return Row(
      children: [
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeRight: true,
            child: ScaffoldMessenger(child: list),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeLeft: true,
            child: ScaffoldMessenger(child: detail),
          ),
        ),
      ],
    );
  }
}

class NoTagSelected extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmptyStateCard(child: Text('Choose a tag to see it here')),
    );
  }
}
