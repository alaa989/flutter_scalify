import 'package:flutter/material.dart';
import 'scalify_config.dart';

enum ScreenType {
  watch,
  mobile,
  tablet,
  smallDesktop,
  desktop,
  largeDesktop,
}

/// Immutable container for responsive metrics with Quantized IDs for Stability.
class ResponsiveData {
  final Size size;
  final double textScaleFactor;
  final ScreenType screenType;
  final ScalifyConfig config;

  /// Width scale ratio.
  final double scaleWidth;

  /// Height scale ratio.
  final double scaleHeight;

  /// General scale factor.
  final double scaleFactor;

  // --- Quantized IDs for Equality Checks (Optimization) ---
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

  /// Identity data with default values.
  static const ResponsiveData identity = ResponsiveData._(
    size: Size(375, 812),
    textScaleFactor: 1.0,
    screenType: ScreenType.mobile,
    config: ScalifyConfig(),
    scaleWidth: 1.0,
    scaleHeight: 1.0,
    scaleFactor: 1.0,
    scaleWidthId: 1000,
    scaleHeightId: 1000,
    scaleFactorId: 1000,
    textScaleFactorId: 100,
  );

  /// Helper to check if the screen is small.
  bool get isSmallScreen =>
      screenType == ScreenType.watch || screenType == ScreenType.mobile;

  /// Helper to check if the screen is medium.
  bool get isMediumScreen =>
      screenType == ScreenType.tablet || screenType == ScreenType.smallDesktop;

  /// Helper to check if the screen is large.
  bool get isLargeScreen =>
      screenType == ScreenType.desktop || screenType == ScreenType.largeDesktop;

  /// Whether the current width exceeds the design desktop breakpoint.
  bool get isOverMaxWidth => size.width > config.desktopBreakpoint;

  /// Factory to compute [ResponsiveData] from [MediaQueryData].
  factory ResponsiveData.fromMediaQuery(
      MediaQueryData? media, ScalifyConfig cfg) {
    if (media == null) return ResponsiveData.identity;

    final width = media.size.width;
    final height = media.size.height;

    if (width == 0 || height == 0) return ResponsiveData.identity;

    // ScreenType Logic
    ScreenType type;
    if (width < cfg.mobileBreakpoint) {
      type =
          (width < cfg.watchBreakpoint) ? ScreenType.watch : ScreenType.mobile;
    } else if (width < cfg.smallDesktopBreakpoint) {
      type = (width < cfg.tabletBreakpoint)
          ? ScreenType.tablet
          : ScreenType.smallDesktop;
    } else {
      type = (width < cfg.desktopBreakpoint)
          ? ScreenType.desktop
          : ScreenType.largeDesktop;
    }

    // Scale Logic
    double calculatedScaleWidth = width / cfg.designWidth;
    if (width > cfg.memoryProtectionThreshold) {
      final thresholdScale = cfg.memoryProtectionThreshold / cfg.designWidth;
      final excessWidth = width - cfg.memoryProtectionThreshold;
      calculatedScaleWidth = thresholdScale +
          ((excessWidth / cfg.designWidth) * cfg.highResScaleFactor);
    }

    final double finalScaleWidth =
        calculatedScaleWidth.clamp(cfg.minScale, cfg.maxScale);
    final double finalScaleHeight =
        (height / cfg.designHeight).clamp(cfg.minScale, cfg.maxScale);
    final double finalCombined = finalScaleWidth;

    // Use standard text scale factor
    final double systemTextScaleFactor = media.textScaleFactor;

    return ResponsiveData._(
      size: Size(width, height),
      textScaleFactor: systemTextScaleFactor,
      screenType: type,
      config: cfg,
      scaleWidth: finalScaleWidth,
      scaleHeight: finalScaleHeight,
      scaleFactor: finalCombined,
      scaleWidthId: (finalScaleWidth * 1000).round(),
      scaleHeightId: (finalScaleHeight * 1000).round(),
      scaleFactorId: (finalCombined * 1000).round(),
      textScaleFactorId: (systemTextScaleFactor * 100).round(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResponsiveData) return false;

    final tol = config.rebuildWidthPxThreshold;
    return (other.size.width - size.width).abs() < tol &&
        (other.size.height - size.height).abs() < tol &&
        other._scaleFactorId == _scaleFactorId &&
        other._scaleWidthId == _scaleWidthId &&
        other._scaleHeightId == _scaleHeightId &&
        other._textScaleFactorId == _textScaleFactorId &&
        other.screenType == screenType;
  }

  @override
  int get hashCode {
    return Object.hash(
      _scaleFactorId,
      _scaleWidthId,
      _scaleHeightId,
      _textScaleFactorId,
      screenType,
    );
  }
}
