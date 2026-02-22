import 'package:flutter/material.dart';
import 'responsive_data.dart';
import 'responsive_extensions.dart';

/// A widget that applies different [BoxConstraints] based on the current
/// screen type — allowing precise control over min/max width and height
/// per device category.
///
/// ## Performance Design
/// - Single [ScreenType] lookup per build — O(1)
/// - No [LayoutBuilder] — constraints are applied via a simple [ConstrainedBox]
/// - Fallback chain avoids null checks: largeDesktop → desktop → tablet → mobile
///
/// ## Example
///
/// ```dart
/// ResponsiveConstraints(
///   mobile: BoxConstraints(maxWidth: 350, minHeight: 100),
///   tablet: BoxConstraints(maxWidth: 500, minHeight: 120),
///   desktop: BoxConstraints(maxWidth: 800, minHeight: 150),
///   child: ProductCard(),
/// )
/// ```
///
/// ## With Alignment
///
/// ```dart
/// ResponsiveConstraints(
///   alignment: Alignment.center,
///   mobile: BoxConstraints(maxWidth: 350),
///   desktop: BoxConstraints(maxWidth: 600),
///   child: LoginForm(),
/// )
/// ```
class ResponsiveConstraints extends StatelessWidget {
  /// The child widget to constrain.
  final Widget child;

  /// Constraints for mobile/watch screens. **Required** as the fallback.
  final BoxConstraints mobile;

  /// Constraints for tablet screens. Falls back to [mobile].
  final BoxConstraints? tablet;

  /// Constraints for small desktop screens. Falls back to [tablet] → [mobile].
  final BoxConstraints? smallDesktop;

  /// Constraints for desktop screens. Falls back down the chain.
  final BoxConstraints? desktop;

  /// Constraints for large desktop screens. Falls back down the chain.
  final BoxConstraints? largeDesktop;

  /// Optional alignment of the constrained child within its parent.
  /// If null, no [Align] wrapper is added.
  final AlignmentGeometry? alignment;

  /// Whether to scale the constraint values using Scalify's scale factor.
  /// Default: `false` (uses raw pixel values).
  ///
  /// When `true`, all constraint values are multiplied by the current
  /// scale factor, making them proportional to the design dimensions.
  final bool scaleConstraints;

  /// Creates a [ResponsiveConstraints] widget.
  const ResponsiveConstraints({
    super.key,
    required this.child,
    required this.mobile,
    this.tablet,
    this.smallDesktop,
    this.desktop,
    this.largeDesktop,
    this.alignment,
    this.scaleConstraints = false,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;
    final rawConstraints = _resolveConstraints(data.screenType);

    final effectiveConstraints = scaleConstraints
        ? _scaleBoxConstraints(rawConstraints, data.scaleFactor)
        : rawConstraints;

    Widget result = ConstrainedBox(
      constraints: effectiveConstraints,
      child: child,
    );

    if (alignment != null) {
      result = Align(alignment: alignment!, child: result);
    }

    return result;
  }

  /// Resolves constraints based on screen type with a waterfall fallback.
  @pragma('vm:prefer-inline')
  BoxConstraints _resolveConstraints(ScreenType screenType) {
    switch (screenType) {
      case ScreenType.largeDesktop:
        return largeDesktop ?? desktop ?? smallDesktop ?? tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? smallDesktop ?? tablet ?? mobile;
      case ScreenType.smallDesktop:
        return smallDesktop ?? tablet ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.mobile:
      case ScreenType.watch:
        return mobile;
    }
  }

  /// Scales all non-infinite constraint values by the given scale factor.
  static BoxConstraints _scaleBoxConstraints(
    BoxConstraints c,
    double scale,
  ) {
    return BoxConstraints(
      minWidth: c.minWidth.isFinite ? c.minWidth * scale : c.minWidth,
      maxWidth: c.maxWidth.isFinite ? c.maxWidth * scale : c.maxWidth,
      minHeight: c.minHeight.isFinite ? c.minHeight * scale : c.minHeight,
      maxHeight: c.maxHeight.isFinite ? c.maxHeight * scale : c.maxHeight,
    );
  }
}
