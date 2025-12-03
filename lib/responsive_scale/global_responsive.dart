import 'package:flutter/material.dart';

import 'responsive_data.dart';

class GlobalResponsive {
  static ResponsiveData? _data;

  static void update(ResponsiveData data) {
    _data = data;
  }

  /// ✅ Safe Getter: لا يرمي Exception بل يعيد قيمة افتراضية
  static ResponsiveData get data {
    if (_data == null) {
      // طباعة تحذير للمطور فقط في وضع الـ Debug
      assert(() {
        debugPrint('⚠️ Warning: ResponsiveProvider not initialized. Using fallback values.');
        return true;
      }());
      
      // إرجاع قيمة افتراضية (Scale = 1.0) لتجنب توقف التطبيق
      return ResponsiveData.identity();
    }
    return _data!;
  }

  static bool get isInitialized => _data != null;

  static void clear() => _data = null;
}