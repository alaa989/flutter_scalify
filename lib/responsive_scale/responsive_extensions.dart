import 'package:flutter/material.dart';
import 'scalify_provider.dart';
import 'responsive_data.dart';
import 'global_responsive.dart';
import 'responsive_helper.dart';

/// Context extension for accessing Responsive Data and Helpers
extension ResponsiveContext on BuildContext {
  /// Access the responsive data directly from the context (via InheritedWidget)
  ResponsiveData get responsiveData => ScalifyProvider.of(this);

  /// Access the helper class for logical operations
  ResponsiveHelper get responsiveHelper =>
      ResponsiveHelper.fromData(responsiveData);

  /// Helper method to return different values based on screen type

  /// Usage: `context.valueByScreen<double>(mobile: 10, tablet: 20)`
  T valueByScreen<T>({
    required T mobile,
    T? watch,
    T? tablet,
    T? smallDesktop,
    T? desktop,
    T? largeDesktop,
  }) {
    return responsiveHelper.valueByScreen(
      mobile: mobile,
      watch: watch,
      tablet: tablet,
      smallDesktop: smallDesktop,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  double w(double value) => value * responsiveData.scaleWidth;
  double h(double value) => value * responsiveData.scaleHeight;
  double r(double value) {
    final s = responsiveData.scaleWidth < responsiveData.scaleHeight
        ? responsiveData.scaleWidth
        : responsiveData.scaleHeight;
    return value * s;
  }

  double sp(double value) => value * responsiveData.scaleFactor;
}

/// Numeric extensions for responsive scaling
extension ResponsiveExtension on num {
  // Access global data directly for performance
  ResponsiveData get _g => GlobalResponsive.data;

  // --- The Performance Magic: Force Inline ---

  @pragma('vm:prefer-inline')
  double get w => this * _g.scaleWidth;

  @pragma('vm:prefer-inline')
  double get h => this * _g.scaleHeight;

  @pragma('vm:prefer-inline')
  double get r {
    final s = _g.scaleWidth < _g.scaleHeight ? _g.scaleWidth : _g.scaleHeight;
    return this * s;
  }

  @pragma('vm:prefer-inline')
  double get s => this * _g.scaleFactor;

  @pragma('vm:prefer-inline')
  double get sc => s;

  @pragma('vm:prefer-inline')
  double get ui => s;

  @pragma('vm:prefer-inline')
  double get iz => s;

  @pragma('vm:prefer-inline')
  double get fz {
    final g = _g;
    double size = this * g.scaleFactor;
    if (g.config.respectTextScaleFactor) {
      size *= g.textScaleFactor;
    }

    return size.clamp(g.config.minFontSize, g.config.maxFontSize);
  }

  @pragma('vm:prefer-inline')
  int get si => (this * _g.scaleFactor).round();

  // --- Percentage Scaling ---
  /// Percentage of screen width (e.g. 50.pw = 50% of screen width)
  @pragma('vm:prefer-inline')
  double get pw => (this / 100) * _g.width;

  /// Percentage of screen height (e.g. 50.hp = 50% of screen height)
  /// Note: We use 'hp' because 'ph' is reserved for horizontal padding.
  @pragma('vm:prefer-inline')
  double get hp => (this / 100) * _g.height;

  // --- Spacing (SizedBox) ---
  SizedBox get sbh => SizedBox(height: h);
  SizedBox get sbw => SizedBox(width: w);

  SizedBox sbhw({double? width}) =>
      SizedBox(height: h, width: width != null ? width * _g.scaleWidth : null);

  SizedBox sbwh({double? height}) => SizedBox(
      width: w, height: height != null ? height * _g.scaleHeight : null);

  // --- Padding ---
  EdgeInsets get p => EdgeInsets.all(s);
  EdgeInsets get ph => EdgeInsets.symmetric(horizontal: w);
  EdgeInsets get pv => EdgeInsets.symmetric(vertical: h);
  EdgeInsets get pt => EdgeInsets.only(top: h);
  EdgeInsets get pb => EdgeInsets.only(bottom: h);
  EdgeInsets get pl => EdgeInsets.only(left: w);
  EdgeInsets get pr => EdgeInsets.only(right: w);

  // --- BorderRadius ---
  BorderRadius get br => BorderRadius.circular(r);

  BorderRadius get brt => BorderRadius.only(
      topLeft: Radius.circular(r), topRight: Radius.circular(r));

  BorderRadius get brb => BorderRadius.only(
      bottomLeft: Radius.circular(r), bottomRight: Radius.circular(r));

  BorderRadius get brl => BorderRadius.only(
      topLeft: Radius.circular(r), bottomLeft: Radius.circular(r));

  BorderRadius get brr => BorderRadius.only(
      topRight: Radius.circular(r), bottomRight: Radius.circular(r));
}

/// `List<num>` padding shorthand with validation (allowed lengths: 1, 2, or 4).
extension EdgeInsetsListExtension on List<num> {
  EdgeInsets get p {
    final len = length;
    // Optimized switch case style logic
    if (len == 1) {
      return EdgeInsets.all(this[0].s);
    }
    if (len == 2) {
      return EdgeInsets.symmetric(horizontal: this[0].w, vertical: this[1].h);
    }
    if (len == 4) {
      return EdgeInsets.fromLTRB(this[0].w, this[1].h, this[2].w, this[3].h);
    }
    // Fail silently or throw based on preference
    throw ArgumentError('Scalify: List must have length 1, 2, or 4.');
  }
}
