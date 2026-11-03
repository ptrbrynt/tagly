import Flutter
import UIKit

/// Streams iPhone Duo geometry to Dart: reserved regions (cameras, fold),
/// hinge status and the physical side of the system's vertical bar.
/// Sends an empty snapshot on devices and OS versions without these APIs.
@MainActor
final class DeviceRegionsPlugin: NSObject, @preconcurrency FlutterStreamHandler {
  private weak var registrar: FlutterPluginRegistrar?
  private var sink: FlutterEventSink?
  private var observer: RegionObserverView?
  private var hinge: [String: Any]?
  private var lastSnapshot: NSDictionary?

  static func register(with registrar: FlutterPluginRegistrar) {
    let instance = DeviceRegionsPlugin()
    instance.registrar = registrar
    FlutterEventChannel(
      name: "com.ptrbrynt.tagly/device_regions",
      binaryMessenger: registrar.messenger()
    ).setStreamHandler(instance)
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    sink = events
    attach()
    send()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    observer?.removeFromSuperview()
    observer = nil
    sink = nil
    lastSnapshot = nil
    return nil
  }

  private func attach() {
    guard sink != nil, observer == nil else { return }
    guard let view = registrar?.viewController?.view else {
      // The Flutter view can attach to its scene after Dart starts listening.
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
        self?.attach()
        self?.send()
      }
      return
    }
    let probe = RegionObserverView(frame: view.bounds) { [weak self] in self?.send() }
    probe.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    observer = probe
    view.addSubview(probe)

    if #available(iOS 27.1, *) {
      probe.registerForTraitChanges(UITraitCollection.systemTraitsAffectingVerticalBarEdge) {
        (_: RegionObserverView, _: UITraitCollection) in probe.onChange()
      }
      view.addInteraction(
        UIHingeInteraction { [weak self] _, update in
          self?.hinge = update.hinge.map(Self.encode)
          self?.send()
        })
    }
  }

  private func send() {
    guard let sink else { return }
    let snapshot = self.snapshot() as NSDictionary
    guard snapshot != lastSnapshot else { return }
    lastSnapshot = snapshot
    sink(snapshot)
  }

  private func snapshot() -> [String: Any] {
    guard #available(iOS 27.1, *), let view = observer?.superview else {
      return ["regions": [], "barSide": NSNull(), "hinge": NSNull()]
    }
    let regions =
      view.reservedRegions(kind: .occlusion).map { Self.encode($0, kind: "occlusion") }
      + view.reservedRegions(kind: .division).map { Self.encode($0, kind: "division") }
    return [
      "regions": regions,
      "barSide": Self.barSide(of: view.traitCollection) ?? NSNull(),
      "hinge": hinge ?? NSNull(),
    ]
  }

  @available(iOS 27.1, *)
  private static func encode(_ region: UIView.ReservedRegion, kind: String) -> [String: Any] {
    [
      "kind": kind,
      "left": region.frame.minX,
      "top": region.frame.minY,
      "width": region.frame.width,
      "height": region.frame.height,
    ]
  }

  @available(iOS 27.1, *)
  private static func encode(_ hinge: UIHinge) -> [String: Any] {
    let status =
      switch hinge.status {
      case .closed: "closed"
      case .partiallyOpen: "partiallyOpen"
      case .fullyOpen: "fullyOpen"
      default: "unknown"
      }
    return ["status": status, "angle": hinge.angle]
  }

  /// Bars stay aligned with the hardware, so report the physical side
  /// rather than the layout-relative edge UIKit gives us.
  @available(iOS 27.1, *)
  private static func barSide(of traits: UITraitCollection) -> String? {
    let isRTL = traits.layoutDirection == .rightToLeft
    switch traits.verticalBarEdge {
    case .leading: return isRTL ? "right" : "left"
    case .trailing: return isRTL ? "left" : "right"
    default: return nil
    }
  }
}

@MainActor
private final class RegionObserverView: UIView {
  let onChange: () -> Void

  init(frame: CGRect, onChange: @escaping () -> Void) {
    self.onChange = onChange
    super.init(frame: frame)
    isUserInteractionEnabled = false
    backgroundColor = .clear
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

  override func layoutSubviews() {
    super.layoutSubviews()
    onChange()
  }

  override func safeAreaInsetsDidChange() {
    super.safeAreaInsetsDidChange()
    onChange()
  }
}
