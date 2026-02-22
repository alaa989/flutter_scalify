import 'package:flutter/material.dart';
import 'global_responsive.dart';

/// Defines the base spacing values for the design token system.
///
/// These values are scaled automatically by Scalify's current scale factor.
/// Configure once, use everywhere for consistent spacing.
///
/// ## Example
///
/// ```dart
/// ScalifyConfig(
///   // ... other config
/// )
/// // Then use:
/// Spacing.md.gap   // SizedBox(height: 16 * scaleFactor)
/// Spacing.lg.gapW  // SizedBox(width: 24 * scaleFactor)
/// ```
class SpacingScale {
  /// Extra small spacing value. Default: `4.0`
  final double xs;

  /// Small spacing value. Default: `8.0`
  final double sm;

  /// Medium spacing value. Default: `16.0`
  final double md;

  /// Large spacing value. Default: `24.0`
  final double lg;

  /// Extra large spacing value. Default: `32.0`
  final double xl;

  /// Double extra large spacing value. Default: `48.0`
  final double xxl;

  /// Creates a [SpacingScale] with configurable values.
  const SpacingScale({
    this.xs = 4.0,
    this.sm = 8.0,
    this.md = 16.0,
    this.lg = 24.0,
    this.xl = 32.0,
    this.xxl = 48.0,
  });

  /// Returns the value for a given [Spacing] tier.
  @pragma('vm:prefer-inline')
  double valueOf(Spacing spacing) {
    switch (spacing) {
      case Spacing.xs:
        return xs;
      case Spacing.sm:
        return sm;
      case Spacing.md:
        return md;
      case Spacing.lg:
        return lg;
      case Spacing.xl:
        return xl;
      case Spacing.xxl:
        return xxl;
    }
  }
}

/// Semantic spacing tiers for the design token system.
///
/// Use the extension methods to get scaled [SizedBox], [EdgeInsets],
/// or raw [double] values.
///
/// ## Usage
///
/// ```dart
/// Column(
///   children: [
///     Text('Title'),
///     Spacing.sm.gap,      // scaled vertical SizedBox
///     Text('Subtitle'),
///     Spacing.md.gap,      // scaled vertical SizedBox
///     Text('Body'),
///   ],
/// )
///
/// Container(
///   padding: Spacing.lg.insets,  // scaled EdgeInsets.all
///   margin: Spacing.sm.insetsH,  // scaled EdgeInsets.symmetric(horizontal:)
/// )
/// ```
enum Spacing { xs, sm, md, lg, xl, xxl }

/// The global spacing scale instance.
///
/// Initialized with default values. Override by calling
/// [ScalifySpacing.init] with a custom [SpacingScale].
///
/// ```dart
/// ScalifySpacing.init(const SpacingScale(xs: 2, sm: 4, md: 8, lg: 16, xl: 24, xxl: 32));
/// ```
class ScalifySpacing {
  ScalifySpacing._();

  static SpacingScale _scale = const SpacingScale();

  /// Returns the current spacing scale.
  static SpacingScale get scale => _scale;

  /// Initializes the global spacing scale.
  ///
  /// Call this once at app startup (before or after [ScalifyProvider]).
  /// If not called, default values are used.
  static void init(SpacingScale scale) {
    _scale = scale;
  }

  /// Resets to default values. Intended for testing only.
  static void reset() {
    _scale = const SpacingScale();
  }
}

/// Extension on [Spacing] for generating scaled UI elements.
///
/// All getters use [GlobalResponsive] for the current scale factor,
/// meaning they work without a [BuildContext] — matching the behavior
/// of `.w`, `.h`, `.fz` extensions.
extension SpacingExtension on Spacing {
  /// The raw base value (unscaled) for this spacing tier.
  @pragma('vm:prefer-inline')
  double get _base => ScalifySpacing.scale.valueOf(this);

  /// The current scale factor from [GlobalResponsive].
  @pragma('vm:prefer-inline')
  double get _s => GlobalResponsive.data.scaleFactor;

  // ─── Scaled Raw Values ──────────────────────────────────────────

  /// The scaled value based on the general scale factor.
  ///
  /// Usage: `final space = Spacing.md.value;` → `16 * scaleFactor`
  @pragma('vm:prefer-inline')
  double get value => _base * _s;

  // ─── SizedBox Shortcuts ─────────────────────────────────────────

  /// A vertical [SizedBox] with scaled height.
  ///
  /// Usage: `Spacing.md.gap` → `SizedBox(height: 16 * scaleFactor)`
  SizedBox get gap => SizedBox(height: _base * _s);

  /// A horizontal [SizedBox] with scaled width.
  ///
  /// Usage: `Spacing.md.gapW` → `SizedBox(width: 16 * scaleFactor)`
  SizedBox get gapW => SizedBox(width: _base * _s);

  /// A [SizedBox] with both scaled width and height.
  ///
  /// Usage: `Spacing.md.gapAll` → `SizedBox(width: 16.s, height: 16.s)`
  SizedBox get gapAll {
    final v = _base * _s;
    return SizedBox(width: v, height: v);
  }

  // ─── EdgeInsets Shortcuts ───────────────────────────────────────

  /// `EdgeInsets.all(scaled)`.
  ///
  /// Usage: `padding: Spacing.md.insets`
  EdgeInsets get insets => EdgeInsets.all(_base * _s);

  /// `EdgeInsets.symmetric(horizontal: scaled)`.
  ///
  /// Usage: `padding: Spacing.md.insetsH`
  EdgeInsets get insetsH => EdgeInsets.symmetric(horizontal: _base * _s);

  /// `EdgeInsets.symmetric(vertical: scaled)`.
  ///
  /// Usage: `padding: Spacing.md.insetsV`
  EdgeInsets get insetsV => EdgeInsets.symmetric(vertical: _base * _s);

  /// `EdgeInsets.only(top: scaled)`.
  EdgeInsets get insetsT => EdgeInsets.only(top: _base * _s);

  /// `EdgeInsets.only(bottom: scaled)`.
  EdgeInsets get insetsB => EdgeInsets.only(bottom: _base * _s);

  /// `EdgeInsets.only(left: scaled)`.
  EdgeInsets get insetsL => EdgeInsets.only(left: _base * _s);

  /// `EdgeInsets.only(right: scaled)`.
  EdgeInsets get insetsR => EdgeInsets.only(right: _base * _s);
}
