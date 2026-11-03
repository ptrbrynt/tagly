import 'dart:math' as math;

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tagly/domain/device_regions.dart';
import 'package:tagly/presentation/adaptive/device_regions_scope.dart';
import 'package:tagly/presentation/adaptive/two_pane.dart';

enum BarItemRole {
  /// Prominent actions, like Done, sit directly below navigation controls.
  prominent,
  regular,
}

enum BarItemPriority { low, normal, high }

class BarItem {
  const new({
    required this.label,
    required this.icon,
    this.onPressed,
    this.selectedIcon,
    this.isSelected = false,
    this.showsBadge = false,
    this.priority = .normal,
    this.group = 0,
    this.role = .regular,
    this.menuChildren,
  });

  /// Always required: overflow menus and tooltips show it even when the bar
  /// shows only the icon.
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final bool isSelected;
  final bool showsBadge;
  final VoidCallback? onPressed;
  final BarItemPriority priority;

  /// Items sharing a group sit together; groups are visually separated.
  final int group;
  final BarItemRole role;

  /// When set, the item opens a menu instead of calling [onPressed].
  final List<Widget>? menuChildren;

  int get _visibilityRank =>
      priority.index * 2 + (role == .prominent ? 4 : 0) + (showsBadge ? 1 : 0);
}

/// A scaffold whose toolbar follows the iPhone Duo vertical-controls
/// guidance: on the side the system reports, when this scaffold reaches that
/// edge of the window, and as a standard app bar everywhere else.
class TaglyScaffold extends StatelessWidget {
  const new({
    required this.body,
    this.title,
    this.items = const [],
    this.bottomBar,
    super.key,
  });

  final String? title;
  final List<BarItem> items;
  final Widget body;
  final Widget? bottomBar;

  static const double _itemExtent = 48;
  static const double _itemGap = 4;
  static const double _groupGap = 16;
  static const double _minBarWidth = 72;

  @override
  Widget build(BuildContext context) {
    final regions = DeviceRegionsScope.of(context);
    final padding = MediaQuery.paddingOf(context);
    final edges = PaneEdges.maybeOf(context);
    final (side, sideInset, reachesEdge) = switch (regions.barSide) {
      BarSide.left => (BarSide.left, padding.left, edges?.left ?? true),
      BarSide.right => (BarSide.right, padding.right, edges?.right ?? true),
      null => (null, 0.0, false),
    };
    if (side == null || !reachesEdge) return _horizontal(context);
    // The left app in Split View has its bar on the left but no system
    // column there, so it gets no inset to occupy.
    final barWidth = sideInset > 0 ? sideInset : _minBarWidth;
    return _vertical(context, side, barWidth, regions);
  }

  Widget _horizontal(BuildContext context) {
    final back = _backAction(context);
    final ordered = [
      ...items.where((i) => i.role == .regular),
      ...items.where((i) => i.role == .prominent),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final capacity = math.max(
          1,
          ((constraints.maxWidth - kToolbarHeight - 160) / _itemExtent).floor(),
        );
        final (visible, overflow) = _partition(ordered, capacity);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: back == null ? null : BackButton(onPressed: back),
            title: title == null ? null : Text(title!),
            actions: [
              for (final item in visible) _BarButton(item: item),
              if (overflow.isNotEmpty) _OverflowButton(items: overflow),
            ],
          ),
          body: SafeArea(top: false, bottom: false, child: body),
          bottomNavigationBar: bottomBar,
        );
      },
    );
  }

  Widget _vertical(
    BuildContext context,
    BarSide side,
    double barWidth,
    DeviceRegions regions,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final back = _backAction(context);
    final statusInset = math.max(
      mediaQuery.padding.top,
      _statusInset(mediaQuery.size, side, barWidth, regions),
    );
    final ordered = [
      ...items.where((i) => i.role == .prominent),
      ...items.where((i) => i.role == .regular),
    ];

    final bar = Material(
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox(
        width: barWidth,
        child: Padding(
          padding: EdgeInsets.only(
            top: statusInset,
            bottom: mediaQuery.padding.bottom,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final available =
                  constraints.maxHeight - (back == null ? 0 : _itemExtent);
              final (visible, overflow) = _partitionToHeight(
                ordered,
                available,
              );
              return Column(
                children: [
                  if (back != null) BackButton(onPressed: back),
                  ..._withGroupGaps(visible),
                  if (overflow.isNotEmpty) ...[
                    const SizedBox(height: _itemGap),
                    _OverflowButton(items: overflow),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );

    final content = MediaQuery(
      data: mediaQuery.copyWith(
        padding: side == .left
            ? mediaQuery.padding.copyWith(left: 0)
            : mediaQuery.padding.copyWith(right: 0),
        viewPadding: side == .left
            ? mediaQuery.viewPadding.copyWith(left: 0)
            : mediaQuery.viewPadding.copyWith(right: 0),
      ),
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (context) => Column(
              crossAxisAlignment: .stretch,
              children: [
                if (title case final title?)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      MediaQuery.paddingOf(context).top + 12,
                      16,
                      4,
                    ),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                  ),
                Expanded(
                  child: title == null
                      ? body
                      : MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: body,
                        ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: bottomBar,
      ),
    );

    // Bars stay with the hardware, so lay out physically, ignoring RTL.
    return Directionality(
      textDirection: .ltr,
      child: Row(
        crossAxisAlignment: .stretch,
        children: [
          if (side == .left) bar,
          Expanded(
            child: Directionality(
              textDirection: Directionality.of(context),
              child: content,
            ),
          ),
          if (side == .right) bar,
        ],
      ),
    );
  }

  /// The system's status area sits at the top of the bar's column; start
  /// our controls below any reserved region that occupies it.
  double _statusInset(
    Size size,
    BarSide side,
    double barWidth,
    DeviceRegions regions,
  ) {
    final column = side == .left
        ? Rect.fromLTWH(0, 0, barWidth, size.height)
        : Rect.fromLTWH(size.width - barWidth, 0, barWidth, size.height);
    var inset = 0.0;
    for (final region in regions.regions) {
      final rect = region.rect;
      if (region.kind == .occlusion &&
          rect.overlaps(column) &&
          rect.top < size.height / 2) {
        inset = math.max(inset, rect.bottom);
      }
    }
    return inset;
  }

  VoidCallback? _backAction(BuildContext context) {
    if (DetailPaneRoot.hidesBack(context)) return null;
    final navigator = Navigator.of(context);
    if (navigator.canPop()) return navigator.maybePop;
    final router = GoRouter.maybeOf(context);
    if (router != null && router.canPop()) return router.pop;
    return null;
  }

  List<Widget> _withGroupGaps(List<BarItem> visible) => [
    for (var i = 0; i < visible.length; i++) ...[
      if (i > 0)
        SizedBox(
          height: visible[i].group == visible[i - 1].group
              ? _itemGap
              : _groupGap,
        ),
      _BarButton(item: visible[i]),
    ],
  ];

  static double _heightOf(List<BarItem> visible, {required bool overflow}) {
    var height = 0.0;
    for (var i = 0; i < visible.length; i++) {
      if (i > 0) {
        height += visible[i].group == visible[i - 1].group
            ? _itemGap
            : _groupGap;
      }
      height += _itemExtent;
    }
    if (overflow) height += _itemGap + _itemExtent;
    return height;
  }

  static (List<BarItem>, List<BarItem>) _partitionToHeight(
    List<BarItem> ordered,
    double available,
  ) {
    for (var capacity = ordered.length; capacity > 0; capacity--) {
      final (visible, overflow) = _partition(ordered, capacity);
      final height = _heightOf(visible, overflow: overflow.isNotEmpty);
      if (height <= available) return (visible, overflow);
    }
    return (const [], ordered);
  }

  /// Fits [ordered] into [capacity] slots, one of which goes to the overflow
  /// button if anything overflows. Lower-priority items go first and, among
  /// equals, items further along the bar go before earlier ones.
  static (List<BarItem>, List<BarItem>) _partition(
    List<BarItem> ordered,
    int capacity,
  ) {
    if (ordered.length <= capacity) return (ordered, const []);
    final removeCount = ordered.length - math.max<int>(0, capacity - 1);
    final removalOrder = List.generate(ordered.length, (i) => i)
      ..sort((a, b) {
        final byRank = ordered[a]._visibilityRank.compareTo(
          ordered[b]._visibilityRank,
        );
        return byRank != 0 ? byRank : b.compareTo(a);
      });
    final removed = removalOrder.take(removeCount).toSet();
    return (
      [
        for (var i = 0; i < ordered.length; i++)
          if (!removed.contains(i)) ordered[i],
      ],
      [
        for (var i = 0; i < ordered.length; i++)
          if (removed.contains(i)) ordered[i],
      ],
    );
  }
}

/// Marks a route as the first page of a detail pane, which has no Back
/// button while the list it belongs to is visible beside it.
class DetailPaneRoot extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  static bool hidesBack(BuildContext context) =>
      context.findAncestorWidgetOfExactType<DetailPaneRoot>() != null &&
      (context
              .dependOnInheritedWidgetOfExactType<SplitDetailScope>()
              ?.isSplit ??
          false);

  @override
  Widget build(BuildContext context) => child;
}

/// Tells detail pages whether their list is currently shown beside them.
class SplitDetailScope extends InheritedWidget {
  const new({required this.isSplit, required super.child, super.key});

  final bool isSplit;

  @override
  bool updateShouldNotify(SplitDetailScope oldWidget) =>
      isSplit != oldWidget.isSplit;
}

class _BarButton extends StatelessWidget {
  const new({required this.item});

  final BarItem item;

  @override
  Widget build(BuildContext context) {
    Widget icon(IconData data) =>
        Badge(isLabelVisible: item.showsBadge, child: Icon(data));

    if (item.menuChildren case final menuChildren?) {
      return MenuAnchor(
        menuChildren: menuChildren,
        builder: (context, controller, _) => IconButton(
          tooltip: item.label,
          icon: icon(item.icon),
          onPressed: () =>
              controller.isOpen ? controller.close() : controller.open(),
        ),
      );
    }
    return IconButton(
      tooltip: item.label,
      isSelected: item.isSelected,
      icon: icon(item.icon),
      selectedIcon: item.selectedIcon == null ? null : icon(item.selectedIcon!),
      onPressed: item.onPressed,
    );
  }
}

class _OverflowButton extends StatelessWidget {
  const new({required this.items});

  final List<BarItem> items;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        for (final item in items)
          if (item.menuChildren case final menuChildren?)
            SubmenuButton(
              leadingIcon: Icon(item.icon),
              menuChildren: menuChildren,
              child: Text(item.label),
            )
          else
            MenuItemButton(
              leadingIcon: Icon(
                item.isSelected ? item.selectedIcon ?? item.icon : item.icon,
              ),
              onPressed: item.onPressed,
              child: Text(item.label),
            ),
      ],
      builder: (context, controller, _) => IconButton(
        tooltip: 'More',
        icon: const Icon(Icons.more_horiz_rounded),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}
