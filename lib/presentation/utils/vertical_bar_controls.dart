import 'package:material_ui/material_ui.dart';
import 'package:tagly/domain/vertical_bar.dart';

/// Makes the system's vertical bar available to the widgets below it, as
/// [MediaQuery] does for other window metrics.
class VerticalBarScope extends InheritedWidget {
  const new({required this.verticalBar, required super.child, super.key});

  final VerticalBar? verticalBar;

  static VerticalBar? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<VerticalBarScope>()
      ?.verticalBar;

  @override
  bool updateShouldNotify(VerticalBarScope oldWidget) =>
      verticalBar != oldWidget.verticalBar;
}

/// Which edges of the window a subtree reaches. Panes laid out side by side
/// reach one edge each; without this, a subtree reaches both.
class WindowEdges extends InheritedWidget {
  const new({
    required this.left,
    required this.right,
    required super.child,
    super.key,
  });

  final bool left;
  final bool right;

  static bool reaches(BuildContext context, VerticalBarEdge edge) {
    final edges = context.dependOnInheritedWidgetOfExactType<WindowEdges>();
    if (edges == null) return true;
    return edge == VerticalBarEdge.left ? edges.left : edges.right;
  }

  @override
  bool updateShouldNotify(WindowEdges oldWidget) =>
      left != oldWidget.left || right != oldWidget.right;
}

/// Builds [builder], and while the system shows its vertical bar on an edge
/// this subtree reaches, stacks [groups] of controls in the bar's column so
/// they line up with the status bar and camera. Each group sits in its own
/// capsule, as related controls share one in the native vertical bar.
class VerticalBarControls extends StatelessWidget {
  const new({required this.groups, required this.builder, super.key});

  final List<List<Widget>> groups;
  final Widget Function(BuildContext context, {required bool inVerticalBar})
  builder;

  @override
  Widget build(BuildContext context) {
    final bar = VerticalBarScope.of(context);
    if (bar == null || !WindowEdges.reaches(context, bar.edge)) {
      return builder(context, inVerticalBar: false);
    }
    final groups = [
      for (final group in this.groups)
        if (group.isNotEmpty) group,
    ];
    final column = bar.controls;
    // Groups placed by an enclosing layout come first in the column.
    final placedAbove = _PlacedControls.heightOf(context);
    final ownHeight = groups.fold<double>(
      0,
      (height, group) => height + _SideCapsule.heightOf(group) + _groupSpacing,
    );
    // The column is in window coordinates. This subtree starts at the top of
    // the window and reaches the bar's edge, so measure from those.
    final windowWidth = MediaQuery.sizeOf(context).width;
    return Stack(
      children: [
        Positioned.fill(
          child: _PlacedControls(
            height: placedAbove + ownHeight,
            child: builder(context, inVerticalBar: true),
          ),
        ),
        Positioned(
          left: bar.edge == VerticalBarEdge.left ? column.left : null,
          right: bar.edge == VerticalBarEdge.right
              ? windowWidth - column.right
              : null,
          top: column.top + placedAbove,
          width: column.width,
          height: (column.height - placedAbove).clamp(0, double.infinity),
          child: Column(
            spacing: _groupSpacing,
            children: [
              for (final group in groups) _SideCapsule(controls: group),
            ],
          ),
        ),
      ],
    );
  }
}

const _groupSpacing = 8.0;

/// Marks a subtree whose back button an enclosing layout already shows, so
/// [VerticalBarScaffold]s inside it leave theirs out.
class LeadingShownElsewhere extends InheritedWidget {
  const new({required super.child, super.key});

  static bool applies(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LeadingShownElsewhere>() !=
      null;

  @override
  bool updateShouldNotify(LeadingShownElsewhere oldWidget) => false;
}

/// The height of controls already placed at the top of the vertical bar's
/// column by enclosing [VerticalBarControls].
class _PlacedControls extends InheritedWidget {
  const new({required this.height, required super.child});

  final double height;

  static double heightOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_PlacedControls>()?.height ??
      0;

  @override
  bool updateShouldNotify(_PlacedControls oldWidget) =>
      height != oldWidget.height;
}

/// A [Scaffold] whose top bar controls move into the system's vertical bar
/// while it is shown, with the title moving into the content above [body].
class VerticalBarScaffold extends StatelessWidget {
  const new({
    required this.title,
    required this.body,
    this.leading,
    this.actions = const [],
    this.automaticallyImplyLeading = true,
    this.floatingActionButton,
    super.key,
  });

  final Widget title;
  final Widget body;
  final Widget? leading;
  final List<Widget> actions;
  final bool automaticallyImplyLeading;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final leading = LeadingShownElsewhere.applies(context)
        ? null
        : this.leading ??
              (automaticallyImplyLeading &&
                      (ModalRoute.of(context)?.impliesAppBarDismissal ?? false)
                  ? const BackButton()
                  : null);
    return VerticalBarControls(
      groups: [
        [?leading],
        actions,
      ],
      builder: (context, {required inVerticalBar}) => Scaffold(
        appBar: inVerticalBar
            ? null
            : AppBar(
                leading: leading,
                automaticallyImplyLeading: false,
                title: title,
                actions: actions,
              ),
        body: inVerticalBar
            ? Column(
                crossAxisAlignment: .stretch,
                children: [
                  _TitleHeader(title: title),
                  Expanded(child: body),
                ],
              )
            : body,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}

class _TitleHeader extends StatelessWidget {
  const new({required this.title});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: kToolbarHeight,
        child: Padding(
          padding: const .symmetric(horizontal: 16),
          child: Align(
            alignment: .centerLeft,
            child: DefaultTextStyle(
              style:
                  theme.appBarTheme.titleTextStyle ??
                  theme.textTheme.titleLarge!,
              maxLines: 1,
              overflow: .ellipsis,
              child: title,
            ),
          ),
        ),
      ),
    );
  }
}

/// A raised capsule of icon buttons for the vertical bar: a tonal surface
/// with a soft shadow, standing in for the glass the native controls sit on,
/// in the theme's own colours.
class _SideCapsule extends StatelessWidget {
  const new({required this.controls});

  final List<Widget> controls;

  /// Apple's minimum tap target, which leaves the capsule inside the bar's
  /// 48pt column.
  static const _buttonSize = 44.0;

  static double heightOf(List<Widget> controls) =>
      controls.length * _buttonSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Material(
      color: theme.brightness == Brightness.light
          ? colors.surfaceContainerLowest
          : colors.surfaceContainerHigh,
      elevation: 2,
      shadowColor: colors.shadow.withValues(alpha: 0.4),
      surfaceTintColor: Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.4)),
      ),
      clipBehavior: .antiAlias,
      child: ActionIconTheme(
        data: (ActionIconTheme.of(context) ?? const ActionIconThemeData())
            .copyWith(backButtonIconBuilder: (_) => const _CentredBackIcon()),
        child: IconButtonTheme(
          data: IconButtonThemeData(
            style: IconButton.styleFrom(
              foregroundColor: colors.onSurface,
              fixedSize: const Size.square(_buttonSize),
              minimumSize: const Size.square(_buttonSize),
              padding: .zero,
              tapTargetSize: .shrinkWrap,
            ),
          ),
          child: Column(mainAxisSize: .min, children: controls),
        ),
      ),
    );
  }
}

/// The back chevron, moved to look centred in a round button. Centred by its
/// strokes, it looks pushed toward its open side, so it moves toward its
/// point. The offset was judged by eye on the iPhone Duo simulator.
class _CentredBackIcon extends StatelessWidget {
  const new();

  static const _opticalOffset = -1.5;

  @override
  Widget build(BuildContext context) {
    return switch (Theme.of(context).platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => Transform.translate(
        offset: const Offset(_opticalOffset, 0),
        child: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      _ => const Icon(Icons.arrow_back),
    };
  }
}
