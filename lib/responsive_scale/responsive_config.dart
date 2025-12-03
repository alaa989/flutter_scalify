// lib/responsive_scale/responsive_config.dart

/// Configuration options for flutter_scalify
class ResponsiveConfig {
  final double watchBreakpoint;
  final double mobileBreakpoint;
  final double tabletBreakpoint;
  final double smallDesktopBreakpoint;
  final double desktopBreakpoint;

  /// Whether to respect the system's text scale factor (Accessibility)
  final bool respectTextScaleFactor;

  /// Minimum and Maximum scaling factors to prevent UI explosion on 4K screens
  final double minScale;
  final double maxScale;

  /// Optional horizontal padding when centering a constrained layout (AppWidthLimiter)
  final double outerHorizontalPadding;

  const ResponsiveConfig({
    this.watchBreakpoint = 300.0,
    this.mobileBreakpoint = 600.0,
    this.tabletBreakpoint = 900.0,
    this.smallDesktopBreakpoint = 1200.0,
    this.desktopBreakpoint = 1800.0,
    this.respectTextScaleFactor = true,
    this.minScale = 0.5,
    this.maxScale = 3.0,
    this.outerHorizontalPadding = 16.0,
  });

  ResponsiveConfig copyWith({
    double? watchBreakpoint,
    double? mobileBreakpoint,
    double? tabletBreakpoint,
    double? smallDesktopBreakpoint,
    double? desktopBreakpoint,
    bool? respectTextScaleFactor,
    double? minScale,
    double? maxScale,
    double? outerHorizontalPadding,
  }) {
    return ResponsiveConfig(
      watchBreakpoint: watchBreakpoint ?? this.watchBreakpoint,
      mobileBreakpoint: mobileBreakpoint ?? this.mobileBreakpoint,
      tabletBreakpoint: tabletBreakpoint ?? this.tabletBreakpoint,
      smallDesktopBreakpoint: smallDesktopBreakpoint ?? this.smallDesktopBreakpoint,
      desktopBreakpoint: desktopBreakpoint ?? this.desktopBreakpoint,
      respectTextScaleFactor: respectTextScaleFactor ?? this.respectTextScaleFactor,
      minScale: minScale ?? this.minScale,
      maxScale: maxScale ?? this.maxScale,
      outerHorizontalPadding: outerHorizontalPadding ?? this.outerHorizontalPadding,
    );
  }
}