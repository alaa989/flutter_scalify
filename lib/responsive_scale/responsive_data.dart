import 'package:flutter/material.dart';
import 'responsive_config.dart';

enum ScreenType {
  watch,
  mobile,
  tablet,
  smallDesktop,
  desktop,
  largeDesktop,
}

class ResponsiveData {
  final Size size;
  final double textScaleFactor;
  final ScreenType screenType;
  final ResponsiveConfig config;
  final double scaleWidth;
  final double scaleHeight;
  final double scaleFactor;

  ResponsiveData({
    required this.size,
    required this.textScaleFactor,
    required this.screenType,
    required this.config,
    required this.scaleWidth,
    required this.scaleHeight,
    required this.scaleFactor,
  });

  bool get isSmallScreen =>
      screenType == ScreenType.watch || screenType == ScreenType.mobile;
  bool get isMediumScreen =>
      screenType == ScreenType.tablet || screenType == ScreenType.smallDesktop;
  bool get isLargeScreen =>
      screenType == ScreenType.desktop || screenType == ScreenType.largeDesktop;

  bool get isOverMaxWidth => size.width > config.desktopBreakpoint;

  /// ✅ Safe Fallback: يستخدم عند فشل العثور على Context أو عدم تهيئة البيانات
  factory ResponsiveData.identity({ResponsiveConfig? config}) {
    return ResponsiveData(
      size: const Size(375, 812), // Default Mobile Size
      textScaleFactor: 1.0,
      screenType: ScreenType.mobile,
      config: config ?? const ResponsiveConfig(),
      scaleWidth: 1.0,
      scaleHeight: 1.0,
      scaleFactor: 1.0,
    );
  }

  /// ✅ Safe Calculation: حماية من القيم الصفرية (Web/Desktop init)
  factory ResponsiveData.fromMediaQuery(MediaQueryData? media, ResponsiveConfig config) {
    // 1. حماية: إذا كان الـ media null
    if (media == null) {
      return ResponsiveData.identity(config: config);
    }

    // 2. حماية: إذا كانت الأبعاد صفر (يحدث في الويب أحياناً قبل التحميل الكامل)
    final width = media.size.width.clamp(0.0, double.infinity).toDouble();
    final height = media.size.height.clamp(0.0, double.infinity).toDouble();

    if (width == 0 || height == 0) {
      return ResponsiveData.identity(config: config);
    }

    // المنطق الأساسي للحساب
    ScreenType type;
    if (width < config.watchBreakpoint) {
      type = ScreenType.watch;
    } else if (width < config.mobileBreakpoint) {
      type = ScreenType.mobile;
    } else if (width < config.tabletBreakpoint) {
      type = ScreenType.tablet;
    } else if (width < config.smallDesktopBreakpoint) {
      type = ScreenType.smallDesktop;
    } else if (width < config.desktopBreakpoint) {
      type = ScreenType.desktop;
    } else {
      type = ScreenType.largeDesktop;
    }

    double baseWidthScale;
    switch (type) {
      case ScreenType.watch:
        baseWidthScale = 0.67;
        break;
      case ScreenType.mobile:
        baseWidthScale = 1.0;
        break;
      case ScreenType.tablet:
        baseWidthScale = 1.22;
        break;
      case ScreenType.smallDesktop:
        baseWidthScale = 1.44;
        break;
      case ScreenType.desktop:
        baseWidthScale = 1.67;
        break;
      case ScreenType.largeDesktop:
        baseWidthScale = 1.89;
        break;
    }

    const double designHeight = 800.0;
    double rawHeightScale = (height / designHeight).clamp(0.5, 3.5).toDouble();
    final clampedWidthScale = baseWidthScale.clamp(config.minScale, config.maxScale).toDouble();

    final scaleWidth = clampedWidthScale;
    final scaleHeight = rawHeightScale.clamp(config.minScale, config.maxScale).toDouble();
    final combined = ((scaleWidth + scaleHeight) / 2).clamp(config.minScale, config.maxScale).toDouble();

    return ResponsiveData(
      size: Size(width, height),
     textScaleFactor: media.textScaler.scale(10) / 10,// media is guaranteed non-null here
      screenType: type,
      config: config,
      scaleWidth: scaleWidth,
      scaleHeight: scaleHeight,
      scaleFactor: combined,
    );
  }
}