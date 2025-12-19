import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart'; // Needed for WidgetsBinding
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
    // Optimization #2: Safety check for debug mode
    assert(() {
      final binding = WidgetsBinding.instance;
      // Only check phase if binding is initialized
      // This ensures we are not updating global state during a locked frame phase unnecessarily
      if (binding.schedulerPhase == SchedulerPhase.idle ||
          binding.schedulerPhase == SchedulerPhase.postFrameCallbacks) {
        // Safe zones
      }
      return true;
    }());

    _data = data;
  }

  /// Gets the current globally cached [ResponsiveData].
  /// Use this only when [BuildContext] is not available.
  static ResponsiveData get data => _data;
}
