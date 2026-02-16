import 'package:flutter/foundation.dart';
import 'responsive_data.dart';

/// A global singleton that holds the current [ResponsiveData].
///
/// This allows accessing responsive metrics without a [BuildContext],
/// enabling `num` extensions like `.w`, `.h`, `.fz`, `.s` to work
/// anywhere in the widget tree (including `const` widgets).
///
/// ## Design
///
/// Scalify assumes a **single [ScalifyProvider]** per application.
/// The provider automatically calls [update] during its lifecycle,
/// keeping this singleton in sync with the current screen metrics.
///
/// ## When to use
///
/// Prefer `context.responsiveData` or [ResponsiveBuilder] when a
/// [BuildContext] is available. Use [GlobalResponsive.data] only in
/// scenarios where no context exists (e.g., utility functions, models).
///
/// ## Nested providers
///
/// If multiple [ScalifyProvider]s exist in the tree (e.g., inside
/// [AppWidthLimiter]), the **last one to update** wins globally.
/// This is intentional — the innermost provider reflects the constrained
/// viewport, which is the correct scaling for its subtree.
/// However, `num` extensions outside that subtree will also see the
/// updated values until the outer provider recalculates.
///
/// In practice, this is rarely an issue because [AppWidthLimiter] only
/// creates a nested provider when the screen exceeds `maxWidth`.
class GlobalResponsive {
  GlobalResponsive._();

  static ResponsiveData _data = ResponsiveData.identity;

  /// Updates the global responsive data.
  /// This is called automatically by [ScalifyProvider].
  static void update(ResponsiveData data) {
    _data = data;
  }

  /// Gets the current globally cached [ResponsiveData].
  ///
  /// Use this only when [BuildContext] is not available.
  /// Returns [ResponsiveData.identity] if no [ScalifyProvider] has
  /// initialized yet.
  static ResponsiveData get data => _data;

  /// Resets the global state. Intended for testing only.
  @visibleForTesting
  static void reset() {
    _data = ResponsiveData.identity;
  }
}
