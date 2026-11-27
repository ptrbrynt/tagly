import Flutter
import UIKit

/// Streams the fold's division regions to Dart as
/// `[{left, top, width, height, active}]` in the Flutter view's coordinates.
/// Sends an empty list on devices or OS versions without reserved regions.
final class FoldRegionsPlugin: NSObject, FlutterStreamHandler {
  private let registrar: FlutterPluginRegistrar
  private var observer: UIView?

  private init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
  }

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterEventChannel(
      name: "tagly/fold_regions",
      binaryMessenger: registrar.messenger()
    )
    channel.setStreamHandler(FoldRegionsPlugin(registrar: registrar))
  }

  func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    guard #available(iOS 27.1, *), let view = registrar.viewController?.view else {
      events([[String: Any]]())
      return nil
    }
    let observer = ReservedRegionObserver(onChange: events)
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

/// An invisible view covering the Flutter view. UIKit calls
/// `updateConstraints()` again whenever regions read there change, so this
/// reports every fold and unfold without polling.
@available(iOS 27.1, *)
private final class ReservedRegionObserver: UIView {
  private let onChange: FlutterEventSink
  private var lastReported: NSArray?

  init(onChange: @escaping FlutterEventSink) {
    self.onChange = onChange
    super.init(frame: .zero)
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

  private func report() {
    let regions = reservedRegions(kind: .division, options: .includeInactive)
      .map { region -> [String: Any] in
        [
          "left": region.frame.minX,
          "top": region.frame.minY,
          "width": region.frame.width,
          "height": region.frame.height,
          "active": region.isActive,
        ]
      } as NSArray
    guard regions != lastReported else { return }
    lastReported = regions
    onChange(regions)
  }
}
