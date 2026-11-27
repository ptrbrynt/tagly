import 'package:material_ui/material_ui.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';

const listDetailMinWidth = 720.0;

/// Whether to lay content out side by side: only in a wide, landscape-shaped
/// window. Tall windows, such as the inner display held upright, show one pane
/// or column at a time.
bool fitsTwoPanes(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return size.width >= listDetailMinWidth && size.width > size.height;
}

class ListDetailLayout extends StatefulWidget {
  const new({required this.list, required this.detail, super.key});

  final Widget list;
  final Widget detail;

  @override
  State<ListDetailLayout> createState() => _ListDetailLayoutState();
}

class _ListDetailLayoutState extends State<ListDetailLayout> {
  final _listStorage = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return _ListStorageScope(bucket: _listStorage, child: _layout(context));
  }

  Widget _layout(BuildContext context) {
    if (!fitsTwoPanes(context)) return widget.detail;
    // Each pane gets its own messenger so a snackbar appears only in the pane
    // that raised it, instead of being duplicated in both. Each pane also
    // drops the inset on the edge it shares with the other pane.
    return Row(
      children: [
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeRight: true,
            child: ScaffoldMessenger(child: ListPane(child: widget.list)),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeLeft: true,
            child: ScaffoldMessenger(child: widget.detail),
          ),
        ),
      ],
    );
  }
}

/// Wraps the list wherever it appears, beside the detail or as the first page
/// of the detail navigator, so both share one scroll position.
class ListPane extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_ListStorageScope>();
    if (scope == null) return child;
    return PageStorage(bucket: scope.bucket, child: child);
  }
}

class _ListStorageScope extends InheritedWidget {
  const new({required this.bucket, required super.child});

  final PageStorageBucket bucket;

  @override
  bool updateShouldNotify(_ListStorageScope oldWidget) =>
      bucket != oldWidget.bucket;
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
