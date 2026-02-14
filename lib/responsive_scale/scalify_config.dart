/// Configuration class for [ScalifyProvider].
/// Defines the design baseline, breakpoints, and scaling behavior.
class ScalifyConfig {
  /// Base design width (e.g., 375 for iPhone design).
  final double designWidth;

  /// Base design height (e.g., 812 for iPhone design).
  final double designHeight;

  /// Breakpoint for Watch devices (default `< 300`).
  final double watchBreakpoint;

  /// Breakpoint for Mobile devices (`300 - 600`).
  final double mobileBreakpoint;

  /// Breakpoint for Tablets (`600 - 900`).
  final double tabletBreakpoint;

  /// Breakpoint for Small Desktops (`900 - 1200`).
  final double smallDesktopBreakpoint;

  /// Breakpoint for Desktops (`1200 - 1800`).
  final double desktopBreakpoint;

  /// Whether to respect the system's text scale factor (Accessibility).
  final bool respectTextScaleFactor;

  /// Minimum allowed scale factor (prevents UI from becoming too small).
  final double minScale;

  /// Maximum allowed scale factor (prevents UI from exploding on huge screens).
  final double maxScale;

  /// Minimum allowed font size (prevents text from becoming unreadable).
  final double minFontSize;

  /// Maximum allowed font size (prevents text from exploding on large screens).
  final double maxFontSize;

  /// The width threshold where 4K/Ultra-wide protection kicks in (default `1920`).
  final double memoryProtectionThreshold;

  /// The dampening factor applied to width pixels exceeding [memoryProtectionThreshold].
  final double highResScaleFactor;

  /// Time in milliseconds to debounce resize events (Desktop/Web).
  final int debounceWindowMillis;

  /// The scale difference required to trigger a rebuild.
  final double rebuildScaleThreshold;

  /// The pixel width difference required to trigger a rebuild.
  final double rebuildWidthPxThreshold;

  /// Whether to use legacy tier mapping for [ContainerQuery] (Compatibility).
  final bool legacyContainerTierMapping;

  /// Enable granular notifications using InheritedModel to limit rebuilds (Performance).
  final bool enableGranularNotifications;

  /// Whether to show a deprecation banner in debug mode for legacy settings.
  final bool showDeprecationBanner;

  /// Minimum width before the UI stops shrinking and enables horizontal scrolling.
  final double minWidth;

  /// Creates a new [ScalifyConfig].
  const ScalifyConfig({
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
    this.minFontSize = 6.0,
    this.maxFontSize = 256.0,
    this.memoryProtectionThreshold = 1920.0,
    this.highResScaleFactor = 0.65,
    this.debounceWindowMillis = 120,
    this.rebuildScaleThreshold = 0.01,
    this.rebuildWidthPxThreshold = 4.0,
    this.legacyContainerTierMapping = false,
    this.enableGranularNotifications = false,
    this.showDeprecationBanner = true,
    this.minWidth = 0.0,
  })  : assert(minScale <= maxScale,
            'minScale must be less than or equal to maxScale'),
        assert(
            minFontSize <= maxFontSize, 'minFontSize must be <= maxFontSize'),
        assert(designWidth > 0),
        assert(designHeight > 0);

  /// Creates a copy of this config with the given fields replaced with the new values.
  ScalifyConfig copyWith({
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
    double? minFontSize,
    double? maxFontSize,
    double? memoryProtectionThreshold,
    double? highResScaleFactor,
    int? debounceWindowMillis,
    double? rebuildScaleThreshold,
    double? rebuildWidthPxThreshold,
    bool? legacyContainerTierMapping,
    bool? enableGranularNotifications,
    bool? showDeprecationBanner,
    double? minWidth,
  }) {
    return ScalifyConfig(
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
      minFontSize: minFontSize ?? this.minFontSize,
      maxFontSize: maxFontSize ?? this.maxFontSize,
      memoryProtectionThreshold:
          memoryProtectionThreshold ?? this.memoryProtectionThreshold,
      highResScaleFactor: highResScaleFactor ?? this.highResScaleFactor,
      debounceWindowMillis: debounceWindowMillis ?? this.debounceWindowMillis,
      rebuildScaleThreshold:
          rebuildScaleThreshold ?? this.rebuildScaleThreshold,
      rebuildWidthPxThreshold:
          rebuildWidthPxThreshold ?? this.rebuildWidthPxThreshold,
      legacyContainerTierMapping:
          legacyContainerTierMapping ?? this.legacyContainerTierMapping,
      enableGranularNotifications:
          enableGranularNotifications ?? this.enableGranularNotifications,
      showDeprecationBanner:
          showDeprecationBanner ?? this.showDeprecationBanner,
      minWidth: minWidth ?? this.minWidth,
    );
  }
}
