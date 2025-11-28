
import 'package:flutter/material.dart';
import 'responsive_helper.dart';



class ResponsiveManager {
  static ResponsiveManager? _instance;
  static ResponsiveManager get instance {
    _instance ??= ResponsiveManager._();
    return _instance!;
  }
  
  ResponsiveManager._();
  
  ResponsiveHelper? _helper;
  
  void updateContext(BuildContext context) {
    _helper = ResponsiveHelper(context);
  }
  
  ResponsiveHelper? get helper => _helper;
 
  double fallbackScale(double value) => value;
}


class ResponsiveProvider extends StatelessWidget {
  final Widget child;
  
  const ResponsiveProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    ResponsiveManager.instance.updateContext(context);
    
    return child;
  }
}

// Extension for responsive scaling on num types
extension ResponsiveExtension on num {
  // Text size - حجم النص
  double get fz {
    final helper = ResponsiveManager.instance.helper;
    return helper?.autoScaleFontSize(toDouble()) ?? toDouble();
  }
  
  // Space - المسافات
  double get s {
    final helper = ResponsiveManager.instance.helper;
    return helper?.autoScaleSpace(toDouble()) ?? toDouble();
  }
  
  // Icon size - حجم الأيقونات
  double get iz {
    final helper = ResponsiveManager.instance.helper;
    return helper?.autoScaleIconSize(toDouble()) ?? toDouble();
  }
  
  // Width - العرض
  double get w {
    final helper = ResponsiveManager.instance.helper;
    return helper?.autoScaleDouble(toDouble()) ?? toDouble();
  }
  
  // Height - الارتفاع  
  double get h {
    final helper = ResponsiveManager.instance.helper;
    return helper?.autoScaleDouble(toDouble()) ?? toDouble();
  }
  
  // Radius - نصف القطر
  double get r {
    final helper = ResponsiveManager.instance.helper;
    return helper?.autoScaleSpace(toDouble()) ?? toDouble();
  }
  
  // UI elements - عناصر واجهة المستخدم
  double get ui {
    final helper = ResponsiveManager.instance.helper;
    return helper?.autoScaleUI(toDouble()) ?? toDouble();
  }
  
  // General scaling - التحجيم العام
  double get sc {
    final helper = ResponsiveManager.instance.helper;
    return helper?.autoScale(toDouble()) ?? toDouble();
  }
  
  // For integer values
  int get si {
    final helper = ResponsiveManager.instance.helper;
    return helper?.autoScaleInt(toInt()) ?? toInt();
  }
  
  // Padding shortcuts
  EdgeInsets get p => EdgeInsets.all(s);
  EdgeInsets get ph => EdgeInsets.symmetric(horizontal: s);
  EdgeInsets get pv => EdgeInsets.symmetric(vertical: s);
  EdgeInsets get pt => EdgeInsets.only(top: s);
  EdgeInsets get pb => EdgeInsets.only(bottom: s);
  EdgeInsets get pl => EdgeInsets.only(left: s);
  EdgeInsets get pr => EdgeInsets.only(right: s);
}

// Extension for EdgeInsets creation
extension EdgeInsetsExtension on List<num> {
  EdgeInsets get p {
    if (length == 1) return EdgeInsets.all(this[0].s);
    if (length == 2) return EdgeInsets.symmetric(horizontal: this[0].s, vertical: this[1].s);
    if (length == 4) return EdgeInsets.fromLTRB(this[0].s, this[1].s, this[2].s, this[3].s);
    return EdgeInsets.zero;
  }
}

// Extension for SizedBox shortcuts
extension SizedBoxExtension on num {
  SizedBox get sbh => SizedBox(height: s);
  SizedBox get sbw => SizedBox(width: s);
  SizedBox sbhw({double? width}) => SizedBox(height: s, width: width?.s);
  SizedBox sbwh({double? height}) => SizedBox(width: s, height: height?.s);
}

// Extension for BorderRadius
extension BorderRadiusExtension on num {
  BorderRadius get br => BorderRadius.circular(r);
  BorderRadius get brt => BorderRadius.only(
    topLeft: Radius.circular(r),
    topRight: Radius.circular(r),
  );
  BorderRadius get brb => BorderRadius.only(
    bottomLeft: Radius.circular(r),
    bottomRight: Radius.circular(r),
  );
  BorderRadius get brl => BorderRadius.only(
    topLeft: Radius.circular(r),
    bottomLeft: Radius.circular(r),
  );
  BorderRadius get brr => BorderRadius.only(
    topRight: Radius.circular(r),
    bottomRight: Radius.circular(r),
  );
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