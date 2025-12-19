import 'package:flutter/material.dart';
import 'scalify_config.dart';
import 'responsive_data.dart';

/// Helper class containing utility methods for responsive logic.
class ResponsiveHelper {
  /// The current responsive data.
  final ResponsiveData data;

  /// Creates a [ResponsiveHelper] with the given [data].
  ResponsiveHelper.fromData(this.data);

  /// Creates a [ResponsiveHelper] from the current [context].
  factory ResponsiveHelper.fromContext(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final data = ResponsiveData.fromMediaQuery(mq, const ScalifyConfig());
    return ResponsiveHelper.fromData(data);
  }

  /// Returns the current screen type (mobile, tablet, desktop, etc.).
  ScreenType get screenType => data.screenType;

  /// Returns the system text scale factor.
  double get textScaleFactor => data.textScaleFactor;

  /// Returns true if the device is a watch or mobile.
  bool get isSmallScreen => data.isSmallScreen;

  /// Returns true if the device is a tablet or small desktop.
  bool get isMediumScreen => data.isMediumScreen;

  /// Returns true if the device is a desktop or large desktop.
  bool get isLargeScreen => data.isLargeScreen;

  /// Scales a value by the general scale factor.
  double scale(double value) => value * data.scaleFactor;

  /// Scales a value by the width scale factor.
  double scaleWidth(double value) => value * data.scaleWidth;

  /// Scales a value by the height scale factor.
  double scaleHeight(double value) => value * data.scaleHeight;

  /// Returns a scaled integer value.
  int autoScaleInt(int value) => (scale(value.toDouble()).round());

  /// Returns a value based on the current screen type.
  ///
  /// If a specific value for the current screen type is provided, it is returned.
  /// Otherwise, it falls back to the nearest smaller screen type, eventually defaulting to [mobile].
  T valueByScreen<T>({
    required T mobile,
    T? watch,
    T? tablet,
    T? smallDesktop,
    T? desktop,
    T? largeDesktop,
  }) {
    final type = data.screenType;
    if (type == ScreenType.watch) {
      return watch ?? mobile;
    }
    if (type == ScreenType.mobile) {
      return mobile;
    }
    if (type == ScreenType.tablet) {
      return tablet ?? mobile;
    }
    if (type == ScreenType.smallDesktop) {
      return smallDesktop ?? tablet ?? mobile;
    }
    if (type == ScreenType.desktop) {
      return desktop ?? smallDesktop ?? tablet ?? mobile;
    }
    return largeDesktop ?? mobile;
  }
}
