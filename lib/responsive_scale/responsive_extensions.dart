// lib/responsive_scale/responsive_extensions.dart
import 'package:flutter/material.dart';
import 'responsive_provider.dart';
import 'global_responsive.dart';
import 'responsive_helper.dart';
import 'responsive_data.dart';

extension ResponsiveContext on BuildContext {
  /// ✅ Safe: ResponsiveProvider.of أصبح يعالج الـ null ويعيد fallback
  ResponsiveData get responsiveData => ResponsiveProvider.of(this);

  ResponsiveHelper get responsiveHelper => ResponsiveHelper.fromData(responsiveData);

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

extension ResponsiveExtension on num {
  // ✅ Safe: GlobalResponsive.data أصبح يعيد 1.0 كـ fallback إذا لم تتم التهيئة
  ResponsiveData get _globalData => GlobalResponsive.data;

  double get _scaleWidth => _globalData.scaleWidth;
  double get _scaleHeight => _globalData.scaleHeight;
  double get _scale => _globalData.scaleFactor;

  double get w => (toDouble() * _scaleWidth);
  double get h => (toDouble() * _scaleHeight);
  double get r => (toDouble() * (_scaleWidth < _scaleHeight ? _scaleWidth : _scaleHeight));
  double get sc => (toDouble() * _scale);
  double get ui => (toDouble() * _scale);
  double get iz => (toDouble() * _scale);
  double get s => (toDouble() * _scale);

  double get fz {
    final cfg = _globalData.config;
    var size = toDouble() * _scale;
    if (cfg.respectTextScaleFactor) {
      size *= _globalData.textScaleFactor;
    }
    return size.clamp(6.0, 256.0);
  }

  int get si => (toDouble() * _scale).round();

  EdgeInsets get p => EdgeInsets.all(s);
  EdgeInsets get ph => EdgeInsets.symmetric(horizontal: s);
  EdgeInsets get pv => EdgeInsets.symmetric(vertical: s);
  EdgeInsets get pt => EdgeInsets.only(top: s);
  EdgeInsets get pb => EdgeInsets.only(bottom: s);
  EdgeInsets get pl => EdgeInsets.only(left: s);
  EdgeInsets get pr => EdgeInsets.only(right: s);

  SizedBox get sbh => SizedBox(height: s);
  SizedBox get sbw => SizedBox(width: s);

  SizedBox sbhw({double? width}) => SizedBox(height: s, width: width?.s);
  SizedBox sbwh({double? height}) => SizedBox(width: s, height: height?.s);

  BorderRadius get br => BorderRadius.circular(r);
  BorderRadius get brt => BorderRadius.only(topLeft: Radius.circular(r), topRight: Radius.circular(r));
  BorderRadius get brb => BorderRadius.only(bottomLeft: Radius.circular(r), bottomRight: Radius.circular(r));
  BorderRadius get brl => BorderRadius.only(topLeft: Radius.circular(r), bottomLeft: Radius.circular(r));
  BorderRadius get brr => BorderRadius.only(topRight: Radius.circular(r), bottomRight: Radius.circular(r));
}
/// List<num> extension for EdgeInsets with validation
extension EdgeInsetsExtension on List<num> {
  EdgeInsets get p {
    final length = this.length;
    if (length == 0 || length == 3 || length > 4) {
      throw ArgumentError('Scalify Padding Error: List length must be 1, 2, or 4. Received: $length');
      }
    if (length == 1) {
      return EdgeInsets.all(this[0].s);
    } else if (length == 2) {
      return EdgeInsets.symmetric(horizontal: this[0].s, vertical: this[1].s);
    } else {
      // length == 4
      return EdgeInsets.fromLTRB(this[0].s, this[1].s, this[2].s, this[3].s);
    }
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