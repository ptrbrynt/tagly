import 'package:tagly/config/analytics_service.dart';

class FakeAnalyticsService implements AnalyticsService {
  bool _isTrackingEnabled = false;

  @override
  Future<bool> get isTrackingEnabled async => _isTrackingEnabled;

  @override
  Future<void> enableTracking() async {
    _isTrackingEnabled = true;
  }

  @override
  Future<void> disableTracking() async {
    _isTrackingEnabled = false;
  }

  @override
  void capture({required String eventName, Map<String, Object>? properties}) {}
}
