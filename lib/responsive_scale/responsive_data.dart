// ignore_for_file: deprecated_member_use

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

/// Immutable container for responsive metrics
class ResponsiveData {
  final Size size;
  final double textScaleFactor;
  final ScreenType screenType;
  final ResponsiveConfig config;

  // Precomputed scales for O(1) extension getters
  final double scaleWidth;
  final double scaleHeight;
  final double scaleFactor;

  const ResponsiveData._({
    required this.size,
    required this.textScaleFactor,
    required this.screenType,
    required this.config,
    required this.scaleWidth,
    required this.scaleHeight,
    required this.scaleFactor,
  });

  // identity (safe fallback)
  static const ResponsiveData identity = ResponsiveData._(
    size: Size(375, 812),
    textScaleFactor: 1.0,
    screenType: ScreenType.mobile,
    config: ResponsiveConfig(),
    scaleWidth: 1.0,
    scaleHeight: 1.0,
    scaleFactor: 1.0,
  );

  bool get isSmallScreen =>
      screenType == ScreenType.watch || screenType == ScreenType.mobile;
  bool get isMediumScreen =>
      screenType == ScreenType.tablet || screenType == ScreenType.smallDesktop;
  bool get isLargeScreen =>
      screenType == ScreenType.desktop || screenType == ScreenType.largeDesktop;

  bool get isOverMaxWidth => size.width > config.desktopBreakpoint;

  /// Factory to compute metrics from a MediaQueryData (may be null)
  factory ResponsiveData.fromMediaQuery(
      MediaQueryData? media, ResponsiveConfig cfg) {
    if (media == null) return ResponsiveData.identity;

    final width = media.size.width;
    final height = media.size.height;
    if (!width.isFinite || !height.isFinite || width <= 0 || height <= 0) {
      return ResponsiveData.identity;
    }

    ScreenType type;
    if (width < cfg.watchBreakpoint) {
      type = ScreenType.watch;
    } else if (width < cfg.mobileBreakpoint) {
      type = ScreenType.mobile;
    } else if (width < cfg.tabletBreakpoint) {
      type = ScreenType.tablet;
    } else if (width < cfg.smallDesktopBreakpoint) {
      type = ScreenType.smallDesktop;
    } else if (width < cfg.desktopBreakpoint) {
      type = ScreenType.desktop;
    } else {
      type = ScreenType.largeDesktop;
    }

    // Compute a base width scale (dampened above threshold to save memory on 4K)
    double calculatedScaleWidth;
    if (width <= cfg.memoryProtectionThreshold) {
      calculatedScaleWidth = width / cfg.designWidth;
    } else {
      final thresholdScale = cfg.memoryProtectionThreshold / cfg.designWidth;
      final excessWidth = width - cfg.memoryProtectionThreshold;
      final excessScale =
          (excessWidth / cfg.designWidth) * cfg.highResScaleFactor;
      calculatedScaleWidth = thresholdScale + excessScale;
    }

    // Height scale
    double calculatedScaleHeight = (height / cfg.designHeight);

    // Clamp scales
    final finalScaleWidth =
        calculatedScaleWidth.clamp(cfg.minScale, cfg.maxScale);
    final finalScaleHeight =
        calculatedScaleHeight.clamp(cfg.minScale, cfg.maxScale);

    // Combined factor (prefer width, but safe)
    final finalCombined = finalScaleWidth;

    return ResponsiveData._(
      size: Size(width, height),
      textScaleFactor: media.textScaleFactor,
      screenType: type,
      config: cfg,
      scaleWidth: finalScaleWidth.toDouble(),
      scaleHeight: finalScaleHeight.toDouble(),
      scaleFactor: finalCombined.toDouble(),
    );
  }
}
