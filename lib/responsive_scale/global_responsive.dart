import 'responsive_data.dart';

/// Fast global holder for responsive data.
/// Initialized to identity to avoid null checks in hot paths.
class GlobalResponsive {
  GlobalResponsive._();

  static ResponsiveData _data = ResponsiveData.identity;

  /// Update from provider
  static void update(ResponsiveData data) {
    _data = data;
  }

  /// Extremely fast getter for extension hot paths (no null checks).
  static ResponsiveData get data => _data;

  static bool get isInitialized => _data != ResponsiveData.identity;

  static void reset() => _data = ResponsiveData.identity;
}
