import 'package:flutter/material.dart';
import 'package:flutter_scalify/responsive_scale/responsive_provider.dart';
import 'responsive_data.dart';
import 'global_responsive.dart';
import '_cache.dart';
import 'responsive_helper.dart';

/// Context extension
extension ResponsiveContext on BuildContext {
  ResponsiveData get responsiveData => ResponsiveProvider.of(this);
  ResponsiveHelper get responsiveHelper =>
      ResponsiveHelper.fromData(responsiveData);

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
}

/// Fast API (optional) - use when you need micro-performance inside loops
class ScalifyFast {
  ScalifyFast._();

  static double w(double dp) => dp * GlobalResponsive.data.scaleWidth;
  static double h(double dp) => dp * GlobalResponsive.data.scaleHeight;

  static double r(double dp) {
    final d = GlobalResponsive.data;
    return dp * (d.scaleWidth < d.scaleHeight ? d.scaleWidth : d.scaleHeight);
  }

  static double sc(double val) => val * GlobalResponsive.data.scaleFactor;

  static double fz(double sp) {
    final d = GlobalResponsive.data;
    var size = sp * d.scaleFactor;
    if (d.config.respectTextScaleFactor) size *= d.textScaleFactor;
    return size.clamp(6.0, 256.0);
  }
}

/// Numeric extensions (keep abbreviations)
extension ResponsiveExtension on num {
  // fast access - no null checks
  ResponsiveData get _g => GlobalResponsive.data;

  double get w => toDouble() * _g.scaleWidth;
  double get h => toDouble() * _g.scaleHeight;

  double get r {
    final g = _g;
    final scale = (g.scaleWidth < g.scaleHeight ? g.scaleWidth : g.scaleHeight);
    return toDouble() * scale;
  }

  // spacing / general scale
  double get s => toDouble() * _g.scaleFactor;
  double get sc => s;
  double get ui => s;
  double get iz => s;

  double get fz {
    final g = _g;
    var size = toDouble() * g.scaleFactor;
    if (g.config.respectTextScaleFactor) size *= g.textScaleFactor;
    return size.clamp(6.0, 256.0);
  }

  int get si => (toDouble() * _g.scaleFactor).round();

  // padding helpers — use caching for EdgeInsets.all
  EdgeInsets get p => cachedAll(toDouble(), _g.scaleFactor);
  EdgeInsets get ph => EdgeInsets.symmetric(horizontal: w);
  EdgeInsets get pv => EdgeInsets.symmetric(vertical: h);
  EdgeInsets get pt => EdgeInsets.only(top: h);
  EdgeInsets get pb => EdgeInsets.only(bottom: h);
  EdgeInsets get pl => EdgeInsets.only(left: w);
  EdgeInsets get pr => EdgeInsets.only(right: w);

  // SizedBoxes (no heavy allocations but still handy)
  SizedBox get sbh => SizedBox(height: s);
  SizedBox get sbw => SizedBox(width: s);

  SizedBox sbhw({double? width}) => SizedBox(height: h, width: width?.w);
  SizedBox sbwh({double? height}) => SizedBox(width: w, height: height?.h);

  // Border radius - cached
  BorderRadius get br => cachedCircularRadius(toDouble(), _g.scaleFactor);
  BorderRadius get brt => BorderRadius.only(
      topLeft: Radius.circular(r), topRight: Radius.circular(r));
  BorderRadius get brb => BorderRadius.only(
      bottomLeft: Radius.circular(r), bottomRight: Radius.circular(r));
  BorderRadius get brl => BorderRadius.only(
      topLeft: Radius.circular(r), bottomLeft: Radius.circular(r));
  BorderRadius get brr => BorderRadius.only(
      topRight: Radius.circular(r), bottomRight: Radius.circular(r));
}

/// List<num> padding shorthand with validation (allowed lengths: 1,2,4)
extension EdgeInsetsListExtension on List<num> {
  EdgeInsets get p {
    final len = length;
    if (len == 1) return [this[0]].first.p;
    if (len == 2) {
      return EdgeInsets.symmetric(horizontal: this[0].w, vertical: this[1].h);
    }
    if (len == 4) {
      return EdgeInsets.fromLTRB(this[0].w, this[1].h, this[2].w, this[3].h);
    }
    throw ArgumentError(
        'Scalify Padding Error: List length must be 1, 2, or 4. Received: $len');
  }
}

/*
دليل الاستخدام - Usage Guide:
gg
الأحجام الأساسية - Basic Sizes:
- 16.fz     // حجم النص (text size)
- 20.s      // المسافات (space)
- 24.iz     // حجم الأيقونات (icon size)
- 100.w     // العرض (width)
- 50.h      // الارتفاع (height)
- 12.r      // نصف القطر (radius)
- 48.ui     // عناصر واجهة المستخدم (UI elements)
- 1.5.sc    // التحجيم العام (general scaling)
- 10.si     // القيم الصحيحة (integer values)

الحشو - Padding:
- 16.p      // padding all
- 16.ph     // padding horizontal
- 16.pv     // padding vertical
- 16.pt     // padding top
- 16.pb     // padding bottom
- 16.pl     // padding left
- 16.pr     // padding right
- [16, 24].p  // symmetric padding
- [10, 20, 30, 40].p  // LTRB padding

المسافات - Spacing:
- 20.sbh    // SizedBox height
- 30.sbw    // SizedBox width

نصف القطر - Border Radius:
- 12.br     // circular radius
- 12.brt    // top radius
- 12.brb    // bottom radius
- 12.brl    // left radius
- 12.brr    // right radius

أمثلة - Examples:

Text(
  "مرحبا",
  style: TextStyle(fontSize: 16.fz),
)

Container(
  padding: 16.p,
  margin: [20, 10].p,
  width: 200.w,
  height: 100.h,
  decoration: BoxDecoration(
    borderRadius: 12.br,
  ),
)

Column(
  children: [
    Text("عنوان", style: TextStyle(fontSize: 24.fz)),
    16.sbh,  // مسافة
    Text("نص", style: TextStyle(fontSize: 14.fz)),
  ],
)
*/
//  padding: [16, 8].p,  // أو 16.ph + 8.pv

//  50.sbh,  // أو يمكنك استخدام: SizedBox(height: 50.s)

// Icon size
// Icon(
//   Icons.home,
//   // القديم:
//   // size: context.responsive.autoScaleIconSize(24),

//   // الجديد:
//   size: 24.iz,
// )

// Container(
//   padding: 16.p,                    // padding all 16
//   margin: [20, 10].p,              // horizontal 20, vertical 10
//   width: 200.w,
//   height: 100.h,
//   decoration: BoxDecoration(
//     borderRadius: 12.br,           // border radius 12
//   ),
//   child: Column(
//     children: [
//       Icon(Icons.home, size: 24.iz),
//       16.sbh,                      // SizedBox(height: 16)
//       Text("نص", style: TextStyle(fontSize: 14.tz)),
//     ],
//   ),
// )
