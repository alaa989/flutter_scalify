import 'package:flutter/material.dart';
import 'responsive_provider.dart';
import 'responsive_data.dart';
import 'global_responsive.dart';
import 'responsive_helper.dart';

/// Context extension for accessing Responsive Data and Helpers
extension ResponsiveContext on BuildContext {
  /// Access the responsive data directly from the context (via InheritedWidget)
  ResponsiveData get responsiveData => ResponsiveProvider.of(this);

  /// Access the helper class for logical operations
  ResponsiveHelper get responsiveHelper =>
      ResponsiveHelper.fromData(responsiveData);

  /// Helper method to return different values based on screen type
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
    return size < 6.0 ? 6.0 : (size > 256.0 ? 256.0 : size);
  }

  @pragma('vm:prefer-inline')
  int get si => (this * _g.scaleFactor).round();

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

/// List<num> padding shorthand with validation (allowed lengths: 1,2,4)
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
