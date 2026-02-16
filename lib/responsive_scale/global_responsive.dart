import 'responsive_data.dart';

/// A global singleton that holds the current [ResponsiveData].
/// This allows accessing responsive metrics without a [BuildContext] in rare cases,
/// though using [ResponsiveContext] is preferred.
class GlobalResponsive {
  GlobalResponsive._();

  static ResponsiveData _data = ResponsiveData.identity;

  /// Updates the global responsive data.
  /// This is called automatically by [ScalifyProvider].
  static void update(ResponsiveData data) {
    _data = data;
  }

  /// Gets the current globally cached [ResponsiveData].
  /// Use this only when [BuildContext] is not available.
  static ResponsiveData get data => _data;
}
