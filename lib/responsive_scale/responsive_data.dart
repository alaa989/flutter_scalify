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

/// Immutable container for responsive metrics with Quantized IDs for Stability
class ResponsiveData {
  final Size size;
  final double textScaleFactor;
  final ScreenType screenType;
  final ResponsiveConfig config;

  // Precomputed scales
  final double scaleWidth;
  final double scaleHeight;
  final double scaleFactor;

  // --- Quantized IDs for Equality Checks (Optimization #1) ---
  // These prevent unnecessary rebuilds caused by floating-point precision errors.
  final int _scaleWidthId;
  final int _scaleHeightId;
  final int _scaleFactorId;
  final int _textScaleFactorId;

  const ResponsiveData._({
    required this.size,
    required this.textScaleFactor,
    required this.screenType,
    required this.config,
    required this.scaleWidth,
    required this.scaleHeight,
    required this.scaleFactor,
    required int scaleWidthId,
    required int scaleHeightId,
    required int scaleFactorId,
    required int textScaleFactorId,
  })  : _scaleWidthId = scaleWidthId,
        _scaleHeightId = scaleHeightId,
        _scaleFactorId = scaleFactorId,
        _textScaleFactorId = textScaleFactorId;

  static const ResponsiveData identity = ResponsiveData._(
    size: Size(375, 812),
    textScaleFactor: 1.0,
    screenType: ScreenType.mobile,
    config: ResponsiveConfig(),
    scaleWidth: 1.0,
    scaleHeight: 1.0,
    scaleFactor: 1.0,
    scaleWidthId: 1000,
    scaleHeightId: 1000,
    scaleFactorId: 1000,
    textScaleFactorId: 100,
  );
bool get isSmallScreen =>
      screenType == ScreenType.watch || screenType == ScreenType.mobile;

  bool get isMediumScreen =>
      screenType == ScreenType.tablet || screenType == ScreenType.smallDesktop;
    
  bool get isLargeScreen =>
      screenType == ScreenType.desktop || screenType == ScreenType.largeDesktop;

  bool get isOverMaxWidth => size.width > config.desktopBreakpoint;
  factory ResponsiveData.fromMediaQuery(
      MediaQueryData? media, ResponsiveConfig cfg) {
    if (media == null) return ResponsiveData.identity;

    final width = media.size.width;
    final height = media.size.height;

    if (width == 0 || height == 0) return ResponsiveData.identity;

    // ScreenType Logic
    ScreenType type;
    if (width < cfg.mobileBreakpoint) {
      type = (width < cfg.watchBreakpoint) ? ScreenType.watch : ScreenType.mobile;
    } else if (width < cfg.smallDesktopBreakpoint) {
      type = (width < cfg.tabletBreakpoint) ? ScreenType.tablet : ScreenType.smallDesktop;
    } else {
      type = (width < cfg.desktopBreakpoint) ? ScreenType.desktop : ScreenType.largeDesktop;
    }

    // Scale Logic
    double calculatedScaleWidth = width / cfg.designWidth;
    if (width > cfg.memoryProtectionThreshold) {
      final thresholdScale = cfg.memoryProtectionThreshold / cfg.designWidth;
      final excessWidth = width - cfg.memoryProtectionThreshold;
      calculatedScaleWidth = thresholdScale + 
          ((excessWidth / cfg.designWidth) * cfg.highResScaleFactor);
    }

    final double calculatedScaleHeight = height / cfg.designHeight;

    final double finalScaleWidth = calculatedScaleWidth.clamp(cfg.minScale, cfg.maxScale);
    final double finalScaleHeight = calculatedScaleHeight.clamp(cfg.minScale, cfg.maxScale);
    final double finalCombined = finalScaleWidth;

    return ResponsiveData._(
      size: Size(width, height),
      textScaleFactor: media.textScaleFactor,
      screenType: type,
      config: cfg,
      scaleWidth: finalScaleWidth,
      scaleHeight: finalScaleHeight,
      scaleFactor: finalCombined,
      // Computing IDs (x1000 for precision retention up to 3 decimals)
      scaleWidthId: (finalScaleWidth * 1000).round(),
      scaleHeightId: (finalScaleHeight * 1000).round(),
      scaleFactorId: (finalCombined * 1000).round(),
      textScaleFactorId: (media.textScaleFactor * 100).round(),
    );
  }

  // --- PERFORMANCE MAGIC: Integer-based Equality ---
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResponsiveData) return false;
    
    // Compare Integers (Fast & Stable) instead of Doubles (Unstable)
    return other._scaleFactorId == _scaleFactorId &&
           other._scaleWidthId == _scaleWidthId &&
           other._scaleHeightId == _scaleHeightId &&
           other._textScaleFactorId == _textScaleFactorId &&
           other.size.width.toInt() == size.width.toInt() && // Compare dimensions as Int logic
           other.size.height.toInt() == size.height.toInt() &&
           other.screenType == screenType;
  }

  @override
  int get hashCode {
    return Object.hash(
      _scaleFactorId,
      _scaleWidthId,
      _scaleHeightId,
      _textScaleFactorId,
      size.width.toInt(),
      size.height.toInt(),
      screenType,
    );
  }
}