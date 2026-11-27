import Flutter
import UIKit

/// Streams display geometry that Flutter cannot see to Dart, in the Flutter
/// view's coordinates:
///
/// - `tagly/fold_regions`: the fold's division regions as
///   `[{left, top, width, height, active}]`.
/// - `tagly/vertical_bar`: the column where the system places bar controls
///   while it shows its vertical bar, as `{edge, bar}`, with `edge` one of
///   `left`, `right` or `none`, and `bar` a rect when there is one.
///
/// Devices and OS versions without these APIs get an empty fold list and an
/// `edge` of `none`.
enum DisplayGeometry {
  static func register(with registrar: FlutterPluginRegistrar) {
    GeometryStreamHandler.attach(
      to: "tagly/fold_regions",
      registrar: registrar,
      fallback: [[String: Any]]()
    ) { view in
      guard #available(iOS 27.1, *) else { return [[String: Any]]() }
      return view.reservedRegions(kind: .division, options: .includeInactive)
        .map(regionMap)
    }
    GeometryStreamHandler.attach(
      to: "tagly/vertical_bar",
      registrar: registrar,
      fallback: ["edge": "none"]
    ) { view in
      guard #available(iOS 27.1, *) else { return ["edge": "none"] }
      return verticalBar(in: view)
    }
  }

  @available(iOS 27.1, *)
  private static func verticalBar(in view: UIView) -> [String: Any] {
    guard let edge = physicalEdge(of: view.traitCollection.verticalBarEdge, in: view)
    else { return ["edge": "none"] }
    let bar = barFrame(on: edge, in: view)
    // The layout guide is empty until the first layout pass.
    guard !bar.isEmpty else { return ["edge": "none"] }
    return ["edge": edge == .left ? "left" : "right", "bar": rectMap(bar)]
  }

  /// The column where the system wants bar content on [edge]: below the
  /// status bar and camera, above the home indicator, and centred on them.
  @available(iOS 27.1, *)
  private static func barFrame(on edge: UIRectEdge, in view: UIView) -> CGRect {
    if #available(iOS 27.2, *) {
      return view.layoutGuide(for: .bar(onEdge: edge)).layoutFrame
    }
    // iOS 27.1 has no default bar extent to ask for. Rebuild the frame that
    // iOS 27.2 reports from the inset the system adds for the vertical bar:
    // 12pt in from its inner side and 24pt in from the display edge, which
    // centres it on the camera and status bar, and clear of the occlusion
    // regions above and below.
    let bounds = view.bounds
    let insets = view.safeAreaInsets
    let inset = edge == .left ? insets.left : insets.right
    guard inset > 0 else { return .zero }
    let strip = CGRect(
      x: edge == .left ? bounds.minX : bounds.maxX - inset,
      y: bounds.minY,
      width: inset,
      height: bounds.height - insets.bottom
    )
    var top = strip.minY
    var bottom = strip.maxY
    for region in view.reservedRegions(kind: .occlusion) where region.frame.intersects(strip) {
      if region.frame.midY < strip.midY {
        top = max(top, region.frame.maxY)
      } else {
        bottom = min(bottom, region.frame.minY)
      }
    }
    let x = edge == .left ? strip.minX + 24 : strip.minX + 12
    return CGRect(x: x, y: top, width: inset - 36, height: max(0, bottom - top))
  }

  @available(iOS 27.1, *)
  private static func physicalEdge(
    of edge: UIVerticalBarEdge,
    in view: UIView
  ) -> UIRectEdge? {
    let isRightToLeft = view.effectiveUserInterfaceLayoutDirection == .rightToLeft
    switch edge {
    case .leading: return isRightToLeft ? .right : .left
    case .trailing: return isRightToLeft ? .left : .right
    default: return nil
    }
  }

  @available(iOS 27.1, *)
  private static func regionMap(_ region: UIView.ReservedRegion) -> [String: Any] {
    var map = rectMap(region.frame)
    map["active"] = region.isActive
    return map
  }

  private static func rectMap(_ rect: CGRect) -> [String: Any] {
    ["left": rect.minX, "top": rect.minY, "width": rect.width, "height": rect.height]
  }
}

/// Measures geometry from an invisible view laid over the Flutter view, and
/// sends each new value to a Flutter event channel.
private final class GeometryStreamHandler: NSObject, FlutterStreamHandler {
  private let registrar: FlutterPluginRegistrar
  private let fallback: Any
  private let measure: (UIView) -> Any
  private var observer: UIView?

  private init(
    registrar: FlutterPluginRegistrar,
    fallback: Any,
    measure: @escaping (UIView) -> Any
  ) {
    self.registrar = registrar
    self.fallback = fallback
    self.measure = measure
  }

  static func attach(
    to channelName: String,
    registrar: FlutterPluginRegistrar,
    fallback: Any,
    measure: @escaping (UIView) -> Any
  ) {
    let channel = FlutterEventChannel(
      name: channelName,
      binaryMessenger: registrar.messenger()
    )
    channel.setStreamHandler(
      GeometryStreamHandler(registrar: registrar, fallback: fallback, measure: measure)
    )
  }

  func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    guard #available(iOS 27.1, *), let view = registrar.viewController?.view else {
      events(fallback)
      return nil
    }
    let observer = GeometryObserverView(measure: measure, onChange: events)
    observer.frame = view.bounds
    observer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    observer.isUserInteractionEnabled = false
    view.addSubview(observer)
    self.observer = observer
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    observer?.removeFromSuperview()
    observer = nil
    return nil
  }
}

/// UIKit calls `updateConstraints()` again whenever reserved regions read
/// there change, and the trait registration covers vertical bar changes, so
/// this reports every fold, rotation and bar move without polling.
@available(iOS 27.1, *)
private final class GeometryObserverView: UIView {
  private let measure: (UIView) -> Any
  private let onChange: FlutterEventSink
  private var lastReported: NSObject?

  init(measure: @escaping (UIView) -> Any, onChange: @escaping FlutterEventSink) {
    self.measure = measure
    self.onChange = onChange
    super.init(frame: .zero)
    registerForTraitChanges(UITraitCollection.systemTraitsAffectingVerticalBarEdge) {
      (view: GeometryObserverView, _) in view.report()
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

  override class var requiresConstraintBasedLayout: Bool { true }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    setNeedsUpdateConstraints()
  }

  override func updateConstraints() {
    super.updateConstraints()
    report()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    report()
  }

  override func safeAreaInsetsDidChange() {
    super.safeAreaInsetsDidChange()
    report()
  }

  private func report() {
    guard window != nil, let value = measure(self) as? NSObject else { return }
    guard value != lastReported else { return }
    lastReported = value
    onChange(value)
  }
}
