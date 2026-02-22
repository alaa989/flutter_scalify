import 'package:flutter/material.dart';
import 'responsive_data.dart';
import 'responsive_extensions.dart';
import 'scalify_provider.dart';

/// A responsive [SliverAppBar] that adjusts its height, title style,
/// and flexible space based on the current screen type.
///
/// ## Performance Design
/// - Single [ScalifyProvider.of] lookup per build
/// - No duplicate [LayoutBuilder] — relies on Sliver framework constraints
/// - Title font size scaled via `.fz` for consistency
///
/// ## Example
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     ScalifySliverAppBar(
///       title: 'My Store',
///       mobileExpandedHeight: 200,
///       desktopExpandedHeight: 350,
///       flexibleBackground: Image.asset('assets/banner.jpg', fit: BoxFit.cover),
///     ),
///     ResponsiveGrid(useSliver: true, mobile: 2, desktop: 4, ...),
///   ],
/// )
/// ```
class ScalifySliverAppBar extends StatelessWidget {
  /// The title text.
  final String title;

  /// Title style override. Font size is scaled via `.fz` if not overridden.
  final TextStyle? titleStyle;

  /// Expanded height on mobile/watch. Default: `200.0`.
  final double mobileExpandedHeight;

  /// Expanded height on tablet. Falls back to [mobileExpandedHeight].
  final double? tabletExpandedHeight;

  /// Expanded height on desktop/large desktop. Falls back to [tabletExpandedHeight].
  final double? desktopExpandedHeight;

  /// Background widget for the flexible space (e.g., an image).
  final Widget? flexibleBackground;

  /// Whether the app bar should remain visible when scrolled. Default: `true`.
  final bool pinned;

  /// Whether the app bar should become visible as soon as the user scrolls
  /// towards the app bar. Default: `false`.
  final bool floating;

  /// Whether the flexible space should stretch when over-scrolled. Default: `true`.
  final bool stretch;

  /// Leading widget (e.g., back button).
  final Widget? leading;

  /// Action widgets on the right side.
  final List<Widget>? actions;

  /// Background color. If null, uses theme defaults.
  final Color? backgroundColor;

  /// Foreground color for title/icons. If null, uses theme defaults.
  final Color? foregroundColor;

  /// Elevation. Default: `0.0`.
  final double elevation;

  /// How the flexible space background should be placed. Default: [CollapseMode.parallax].
  final CollapseMode collapseMode;

  /// Creates a [ScalifySliverAppBar].
  const ScalifySliverAppBar({
    super.key,
    required this.title,
    this.titleStyle,
    this.mobileExpandedHeight = 200.0,
    this.tabletExpandedHeight,
    this.desktopExpandedHeight,
    this.flexibleBackground,
    this.pinned = true,
    this.floating = false,
    this.stretch = true,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0.0,
    this.collapseMode = CollapseMode.parallax,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;
    final expandedHeight = _resolveHeight(data.screenType);

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      stretch: stretch,
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: titleStyle ??
              TextStyle(
                fontSize: 18.fz,
                fontWeight: FontWeight.bold,
              ),
        ),
        background: flexibleBackground,
        collapseMode: collapseMode,
        titlePadding: EdgeInsets.only(left: 16.w, bottom: 16.s),
      ),
    );
  }

  /// Resolves expanded height based on screen type with fallback chain.
  @pragma('vm:prefer-inline')
  double _resolveHeight(ScreenType screenType) {
    switch (screenType) {
      case ScreenType.largeDesktop:
      case ScreenType.desktop:
        return desktopExpandedHeight ??
            tabletExpandedHeight ??
            mobileExpandedHeight;
      case ScreenType.smallDesktop:
      case ScreenType.tablet:
        return tabletExpandedHeight ?? mobileExpandedHeight;
      case ScreenType.mobile:
      case ScreenType.watch:
        return mobileExpandedHeight;
    }
  }
}

/// A responsive sliver header that displays different widgets based on
/// the current screen type, designed for use inside [CustomScrollView].
///
/// ## Example
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     ScalifySliverHeader(
///       mobile: SliverToBoxAdapter(child: CompactHeader()),
///       desktop: SliverToBoxAdapter(child: ExpandedHeader()),
///     ),
///     ResponsiveGrid(useSliver: true, ...),
///   ],
/// )
/// ```
class ScalifySliverHeader extends StatelessWidget {
  /// Widget for mobile/watch screens. **Required** as fallback.
  final Widget mobile;

  /// Widget for tablet screens. Falls back to [mobile].
  final Widget? tablet;

  /// Widget for small desktop. Falls back to [tablet] → [mobile].
  final Widget? smallDesktop;

  /// Widget for desktop screens. Falls back down the chain.
  final Widget? desktop;

  /// Widget for large desktop screens. Falls back down the chain.
  final Widget? largeDesktop;

  /// Creates a [ScalifySliverHeader].
  const ScalifySliverHeader({
    super.key,
    required this.mobile,
    this.tablet,
    this.smallDesktop,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;
    return _resolveChild(data.screenType);
  }

  /// Resolves the correct child widget based on screen type.
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
}

/// A responsive [SliverPersistentHeader] that adjusts its max/min height
/// based on the screen type and scales content proportionally.
///
/// ## Example
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     ScalifySliverPersistentHeader(
///       mobileMaxHeight: 80,
///       desktopMaxHeight: 120,
///       builder: (context, shrinkOffset, overlapsContent) {
///         return Container(
///           color: Colors.blue,
///           child: Center(child: Text('Sticky Header')),
///         );
///       },
///     ),
///   ],
/// )
/// ```
class ScalifySliverPersistentHeader extends StatelessWidget {
  /// Builder for the header content.
  final Widget Function(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) builder;

  /// Max height on mobile. **Required** as fallback.
  final double mobileMaxHeight;

  /// Max height on tablet. Falls back to [mobileMaxHeight].
  final double? tabletMaxHeight;

  /// Max height on desktop. Falls back to [tabletMaxHeight].
  final double? desktopMaxHeight;

  /// Min height (collapsed). Default: half of the resolved max height.
  final double? minHeight;

  /// Whether this header should remain pinned. Default: `true`.
  final bool pinned;

  /// Whether this header should float. Default: `false`.
  final bool floating;

  /// Creates a [ScalifySliverPersistentHeader].
  const ScalifySliverPersistentHeader({
    super.key,
    required this.builder,
    required this.mobileMaxHeight,
    this.tabletMaxHeight,
    this.desktopMaxHeight,
    this.minHeight,
    this.pinned = true,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;
    final maxH = _resolveMaxHeight(data.screenType);
    final minH = minHeight ?? (maxH * 0.5);

    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: _ScalifyHeaderDelegate(
        maxHeight: maxH,
        minHeight: minH,
        builder: builder,
      ),
    );
  }

  @pragma('vm:prefer-inline')
  double _resolveMaxHeight(ScreenType screenType) {
    switch (screenType) {
      case ScreenType.largeDesktop:
      case ScreenType.desktop:
        return desktopMaxHeight ?? tabletMaxHeight ?? mobileMaxHeight;
      case ScreenType.smallDesktop:
      case ScreenType.tablet:
        return tabletMaxHeight ?? mobileMaxHeight;
      case ScreenType.mobile:
      case ScreenType.watch:
        return mobileMaxHeight;
    }
  }
}

/// Internal delegate for [ScalifySliverPersistentHeader].
class _ScalifyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double _maxHeight;
  final double _minHeight;
  final Widget Function(BuildContext, double, bool) builder;

  const _ScalifyHeaderDelegate({
    required double maxHeight,
    required double minHeight,
    required this.builder,
  })  : _maxHeight = maxHeight,
        _minHeight = minHeight;

  @override
  double get maxExtent => _maxHeight;

  @override
  double get minExtent => _minHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: builder(context, shrinkOffset, overlapsContent),
    );
  }

  @override
  bool shouldRebuild(covariant _ScalifyHeaderDelegate oldDelegate) {
    return _maxHeight != oldDelegate._maxHeight ||
        _minHeight != oldDelegate._minHeight;
  }
}
