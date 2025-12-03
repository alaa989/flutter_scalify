import 'package:flutter/material.dart';
import 'responsive_config.dart';
import 'responsive_data.dart';

class ResponsiveHelper {
  final ResponsiveData data;

  /// ✅ Safe Constructor: يحمي من null context أو null mediaQuery
  ResponsiveHelper.fromContext(BuildContext context)
      : data = ResponsiveData.fromMediaQuery(
            MediaQuery.maybeOf(context), 
            const ResponsiveConfig()
        );

  ResponsiveHelper.fromData(this.data);

  ScreenType get screenType => data.screenType;
  double get textScaleFactor => data.textScaleFactor;

  bool get isSmallScreen => data.isSmallScreen;
  bool get isMediumScreen => data.isMediumScreen;
  bool get isLargeScreen => data.isLargeScreen;

  double autoScaleDouble(double? mobileValue) => ((mobileValue ?? 0.0) * data.scaleFactor);

  double autoScaleUI(double? mobileValue) => ((mobileValue ?? 0.0) * data.scaleFactor);

  double autoScaleFontSize(double? mobileSize) {
    final safeSize = mobileSize ?? 14.0; // fallback font size
    final cfg = data.config;
    var size = safeSize * data.scaleFactor;
    if (cfg.respectTextScaleFactor) {
      size *= data.textScaleFactor;
    }
    return size.clamp(6.0, 256.0);
  }

  double autoScaleSpace(double? mobileValue) => ((mobileValue ?? 0.0) * data.scaleFactor);

  double autoScaleIconSize(double? mobileSize) => ((mobileSize ?? 24.0) * data.scaleFactor);

  int autoScaleInt(int? mobileValue) => (autoScaleDouble((mobileValue ?? 0).toDouble()).round());

  T valueByScreen<T>({
    required T mobile,
    T? watch,
    T? tablet,
    T? smallDesktop,
    T? desktop,
    T? largeDesktop,
  }) {
    final type = data.screenType;
    if (type == ScreenType.watch && watch != null) return watch;
    if (type == ScreenType.largeDesktop && largeDesktop != null) return largeDesktop;
    if (type == ScreenType.desktop) return desktop ?? largeDesktop ?? smallDesktop ?? tablet ?? mobile;
    if (type == ScreenType.smallDesktop) return smallDesktop ?? tablet ?? mobile;
    if (type == ScreenType.tablet) return tablet ?? mobile;
    return mobile;
  }
}