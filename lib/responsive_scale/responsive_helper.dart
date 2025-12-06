import 'package:flutter/material.dart';
import 'responsive_config.dart';
import 'responsive_data.dart';

class ResponsiveHelper {
  final ResponsiveData data;

  ResponsiveHelper.fromData(this.data);

  factory ResponsiveHelper.fromContext(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final data = ResponsiveData.fromMediaQuery(mq, const ResponsiveConfig());
    return ResponsiveHelper.fromData(data);
  }

  ScreenType get screenType => data.screenType;
  double get textScaleFactor => data.textScaleFactor;

  bool get isSmallScreen => data.isSmallScreen;
  bool get isMediumScreen => data.isMediumScreen;
  bool get isLargeScreen => data.isLargeScreen;

  double scale(double value) => value * data.scaleFactor;
  double scaleWidth(double value) => value * data.scaleWidth;
  double scaleHeight(double value) => value * data.scaleHeight;

  int autoScaleInt(int value) => (scale(value.toDouble()).round());

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
