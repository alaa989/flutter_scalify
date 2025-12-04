class ResponsiveConfig {
  // Base design dimensions (common mobile design width/height)
  final double designWidth;
  final double designHeight;

  // Breakpoints
  final double watchBreakpoint;
  final double mobileBreakpoint;
  final double tabletBreakpoint;
  final double smallDesktopBreakpoint;
  final double desktopBreakpoint;

  // Accessibility
  final bool respectTextScaleFactor;

  // Clamping for scale factors
  final double minScale;
  final double maxScale;

  // 4K memory-protection threshold and damping factor
  final double memoryProtectionThreshold;
  final double highResScaleFactor;

  // Debounce & thresholds for rebuild notification
  final int debounceWindowMillis;
  final double rebuildScaleThreshold; // minimal change in scaleFactor to notify
  final double rebuildWidthPxThreshold; // minimal change in px to notify

  const ResponsiveConfig({
    this.designWidth = 375.0,
    this.designHeight = 812.0,
    this.watchBreakpoint = 300.0,
    this.mobileBreakpoint = 600.0,
    this.tabletBreakpoint = 900.0,
    this.smallDesktopBreakpoint = 1200.0,
    this.desktopBreakpoint = 1800.0,
    this.respectTextScaleFactor = true,
    this.minScale = 0.5,
    this.maxScale = 4.0,
    this.memoryProtectionThreshold = 1920.0,
    this.highResScaleFactor = 0.65,
    this.debounceWindowMillis = 120,
    this.rebuildScaleThreshold = 0.005,
    this.rebuildWidthPxThreshold = 3.0,
  });

  ResponsiveConfig copyWith({
    double? designWidth,
    double? designHeight,
    double? watchBreakpoint,
    double? mobileBreakpoint,
    double? tabletBreakpoint,
    double? smallDesktopBreakpoint,
    double? desktopBreakpoint,
    bool? respectTextScaleFactor,
    double? minScale,
    double? maxScale,
    double? memoryProtectionThreshold,
    double? highResScaleFactor,
    int? debounceWindowMillis,
    double? rebuildScaleThreshold,
    double? rebuildWidthPxThreshold,
  }) {
    return ResponsiveConfig(
      designWidth: designWidth ?? this.designWidth,
      designHeight: designHeight ?? this.designHeight,
      watchBreakpoint: watchBreakpoint ?? this.watchBreakpoint,
      mobileBreakpoint: mobileBreakpoint ?? this.mobileBreakpoint,
      tabletBreakpoint: tabletBreakpoint ?? this.tabletBreakpoint,
      smallDesktopBreakpoint:
          smallDesktopBreakpoint ?? this.smallDesktopBreakpoint,
      desktopBreakpoint: desktopBreakpoint ?? this.desktopBreakpoint,
      respectTextScaleFactor:
          respectTextScaleFactor ?? this.respectTextScaleFactor,
      minScale: minScale ?? this.minScale,
      maxScale: maxScale ?? this.maxScale,
      memoryProtectionThreshold:
          memoryProtectionThreshold ?? this.memoryProtectionThreshold,
      highResScaleFactor: highResScaleFactor ?? this.highResScaleFactor,
      debounceWindowMillis: debounceWindowMillis ?? this.debounceWindowMillis,
      rebuildScaleThreshold:
          rebuildScaleThreshold ?? this.rebuildScaleThreshold,
      rebuildWidthPxThreshold:
          rebuildWidthPxThreshold ?? this.rebuildWidthPxThreshold,
    );
  }
}
