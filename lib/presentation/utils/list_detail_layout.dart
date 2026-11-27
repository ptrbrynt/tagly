import 'package:material_ui/material_ui.dart';
import 'package:tagly/domain/vertical_bar.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';
import 'package:tagly/presentation/utils/vertical_bar_controls.dart';

const listDetailMinWidth = 720.0;

/// Whether to lay content out side by side: only in a wide, landscape-shaped
/// window. Tall windows, such as the inner display held upright, show one pane
/// or column at a time.
bool fitsTwoPanes(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return size.width >= listDetailMinWidth && size.width > size.height;
}

/// Windows shorter than this, such as the outer display in landscape or a
/// window with Picture in Picture pinned above it, get compact controls so
/// content keeps most of the height.
const shortWindowMaxHeight = 520.0;

bool isShortWindow(BuildContext context) =>
    MediaQuery.sizeOf(context).height < shortWindowMaxHeight;

class ListDetailLayout extends StatefulWidget {
  const new({
    required this.list,
    required this.detail,
    required this.onBack,
    super.key,
  });

  final Widget list;
  final Widget detail;

  /// Leaves the list. While the system's vertical bar sits on the detail
  /// pane's edge, its back button goes there, at the top of the column, rather
  /// than in a corner of the list pane.
  final VoidCallback onBack;

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
    final backInBar =
        VerticalBarScope.of(context)?.edge == VerticalBarEdge.right;
    return VerticalBarControls(
      groups: [
        if (backInBar) [BackButton(onPressed: widget.onBack)],
      ],
      builder: (context, {required inVerticalBar}) =>
          _panes(context, backInBar: backInBar),
    );
  }

  Widget _panes(BuildContext context, {required bool backInBar}) {
    final list = ListPane(child: widget.list);
    // Each pane gets its own messenger so a snackbar appears only in the pane
    // that raised it, instead of being duplicated in both. Each pane also
    // drops the inset on the edge it shares with the other pane.
    return Row(
      children: [
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeRight: true,
            child: WindowEdges(
              left: true,
              right: false,
              child: ScaffoldMessenger(
                child: LeadingShownElsewhere(isShown: backInBar, child: list),
              ),
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeLeft: true,
            child: WindowEdges(
              left: false,
              right: true,
              child: ScaffoldMessenger(child: widget.detail),
            ),
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
