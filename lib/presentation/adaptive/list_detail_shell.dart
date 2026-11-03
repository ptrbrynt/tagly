import 'package:flutter/material.dart';
import 'package:tagly/presentation/adaptive/tagly_scaffold.dart';
import 'package:tagly/presentation/adaptive/two_pane.dart';
import 'package:tagly/presentation/utils/empty_state_card.dart';

/// Hosts a list and its detail navigator. At regular size the list sits in
/// the primary pane beside the detail; at compact size the detail
/// navigator stacks the list and detail pages as usual.
///
/// The list keeps its state when it moves between those places because
/// both [ListDetailShell] and [ListDetailPage] mount it under [listKey].
class ListDetailShell extends StatelessWidget {
  const ListDetailShell({
    required this.listKey,
    required this.list,
    required this.detailNavigator,
    super.key,
  });

  final GlobalKey listKey;
  final Widget list;
  final Widget detailNavigator;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSplit = isRegularLayout(constraints.biggest);
        return SplitDetailScope(
          isSplit: isSplit,
          child: isSplit
              ? TwoPane(
                  allowedAxes: const {Axis.horizontal},
                  primary: KeyedSubtree(key: listKey, child: list),
                  secondary: detailNavigator,
                )
              : detailNavigator,
        );
      },
    );
  }
}

/// The list route's page inside the detail navigator: the list itself at
/// compact size, or the empty detail state while the list is beside it.
class ListDetailPage extends StatelessWidget {
  const ListDetailPage({
    required this.listKey,
    required this.list,
    required this.emptyDetailMessage,
    super.key,
  });

  final GlobalKey listKey;
  final Widget list;
  final String emptyDetailMessage;

  @override
  Widget build(BuildContext context) {
    final isSplit =
        context
            .dependOnInheritedWidgetOfExactType<SplitDetailScope>()
            ?.isSplit ??
        false;
    if (!isSplit) return KeyedSubtree(key: listKey, child: list);
    return TaglyScaffold(
      body: EmptyStateCard(child: Text(emptyDetailMessage)),
    );
  }
}

/// Replaces the detail without a transition while its list is beside it,
/// and slides like any other page otherwise. One page type for both keeps
/// the route, and the tag's state, alive as the device folds and unfolds.
class DetailPanePage extends Page<void> {
  const DetailPanePage({required this.child, super.key});

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) => _DetailPaneRoute(this);
}

class _DetailPaneRoute extends PageRoute<void>
    with MaterialRouteTransitionMixin {
  _DetailPaneRoute(DetailPanePage page) : super(settings: page);

  @override
  Widget buildContent(BuildContext context) =>
      (settings as DetailPanePage).child;

  @override
  bool get maintainState => true;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final isSplit =
        context
            .dependOnInheritedWidgetOfExactType<SplitDetailScope>()
            ?.isSplit ??
        false;
    if (isSplit) return child;
    return super.buildTransitions(
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
