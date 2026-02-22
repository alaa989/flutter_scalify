import 'package:flutter/material.dart';
import 'responsive_data.dart';
import 'responsive_extensions.dart';

/// The type of transition animation used between responsive layouts.
enum ResponsiveTransitionType {
  /// Fades between the two layouts.
  fade,

  /// Fades + slides from the appropriate direction.
  fadeSlide,

  /// Scales between the two layouts.
  scale,

  /// Fades + scales simultaneously.
  fadeScale,
}

/// A widget that animates smoothly between different responsive layouts
/// when the screen type changes (e.g., during window resize on Desktop/Web).
///
/// ## Performance Design
/// - Uses [AnimatedSwitcher] internally — Flutter's optimized animation engine
/// - Layout is selected via a single [ScreenType] comparison (O(1))
/// - No animation triggers on sub-pixel changes — only on [ScreenType] change
/// - Uses `RepaintBoundary` to isolate animated subtree repaints
///
/// ## Example
///
/// ```dart
/// AnimatedResponsiveTransition(
///   duration: Duration(milliseconds: 300),
///   transition: ResponsiveTransitionType.fadeSlide,
///   mobile: CompactCard(),
///   tablet: MediumCard(),
///   desktop: ExpandedCard(),
/// )
/// ```
class AnimatedResponsiveTransition extends StatelessWidget {
  /// Widget for mobile/watch screens. **Required** as the fallback.
  final Widget mobile;

  /// Widget for tablet screens. Falls back to [mobile].
  final Widget? tablet;

  /// Widget for small desktop screens. Falls back to [tablet] → [mobile].
  final Widget? smallDesktop;

  /// Widget for desktop screens. Falls back to [smallDesktop] → [tablet] → [mobile].
  final Widget? desktop;

  /// Widget for large desktop screens. Falls back to [desktop] chain.
  final Widget? largeDesktop;

  /// Duration of the transition animation. Default: 300ms.
  final Duration duration;

  /// The animation curve. Default: [Curves.easeInOut].
  final Curve curve;

  /// The type of transition animation. Default: [ResponsiveTransitionType.fade].
  final ResponsiveTransitionType transition;

  /// Optional builder for a custom transition. If provided, overrides [transition].
  final AnimatedSwitcherTransitionBuilder? customTransitionBuilder;

  /// Optional layout builder for the animated switcher.
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  /// Creates an [AnimatedResponsiveTransition].
  const AnimatedResponsiveTransition({
    super.key,
    required this.mobile,
    this.tablet,
    this.smallDesktop,
    this.desktop,
    this.largeDesktop,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.transition = ResponsiveTransitionType.fade,
    this.customTransitionBuilder,
    this.layoutBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;
    final child = _resolveChild(data.screenType);

    return RepaintBoundary(
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: curve,
        switchOutCurve: curve,
        transitionBuilder: customTransitionBuilder ?? _buildTransition,
        layoutBuilder: layoutBuilder ?? AnimatedSwitcher.defaultLayoutBuilder,
        child: KeyedSubtree(
          key: ValueKey<ScreenType>(data.screenType),
          child: child,
        ),
      ),
    );
  }

  /// Resolves the correct child widget based on screen type.
  /// Falls back through the chain: largeDesktop → desktop → smallDesktop → tablet → mobile.
  @pragma('vm:prefer-inline')
  Widget _resolveChild(ScreenType screenType) {
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

  /// Builds the transition based on [transition] type.
  Widget _buildTransition(Widget child, Animation<double> animation) {
    switch (transition) {
      case ResponsiveTransitionType.fade:
        return FadeTransition(opacity: animation, child: child);

      case ResponsiveTransitionType.fadeSlide:
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: child,
          ),
        );

      case ResponsiveTransitionType.scale:
        return ScaleTransition(scale: animation, child: child);

      case ResponsiveTransitionType.fadeScale:
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: curve),
            ),
            child: child,
          ),
        );
    }
  }
}
