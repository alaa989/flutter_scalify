import 'package:flutter/material.dart';
import '../responsive_scale/responsive_extensions.dart';
import '../responsive_scale/responsive_provider.dart';

/// A powerful Grid wrapper supporting Manual & Auto-Fit modes.
///
/// Features:
/// - Supports all screen types (Watch, Mobile, Tablet, SmallDesktop, Desktop, LargeDesktop).
/// - Supports [SliverGrid] via [useSliver] with integrated padding.
/// - True Lazy loading via [itemBuilder] for non-sliver mode.
/// - Configurable scaling for [minItemWidth].
class ResponsiveGrid extends StatelessWidget {
  // --- Content ---
  final List<Widget>? children;
  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;

  // --- Styling ---
  final double spacing;
  final double runSpacing;
  final double? childAspectRatio;
  final EdgeInsetsGeometry? padding;

  // --- Layout Strategy (Manual) ---
  final int? watch;
  final int? mobile;
  final int? tablet;
  final int? smallDesktop; // ✅ 900px - 1200px
  final int? desktop; // ✅ 1200px - 1800px
  final int? largeDesktop; // ✅ > 1800px

  // --- Layout Strategy (Auto-Fit) ---
  /// Minimum width in logical pixels.
  final double? minItemWidth;

  /// Whether to apply scaling (.s) to [minItemWidth].
  /// Default is true. Set to false if you want exact pixel precision.
  final bool scaleMinItemWidth;

  // --- Performance & Behavior ---
  final bool useSliver;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGrid({
    super.key,
    this.children,
    this.itemBuilder,
    this.itemCount,
    this.spacing = 10,
    this.runSpacing = 10,
    this.childAspectRatio,
    this.padding,
    this.watch,
    this.mobile,
    this.tablet,
    this.smallDesktop,
    this.desktop,
    this.largeDesktop,
    this.minItemWidth,
    this.scaleMinItemWidth = true,
    this.useSliver = false,
    this.shrinkWrap = false,
    this.physics,
  })  : assert(
          (children != null) != (itemBuilder != null),
          "Provide either 'children' OR 'itemBuilder', not both.",
        ),
        assert(
          itemBuilder == null || itemCount != null,
          "If 'itemBuilder' is used, 'itemCount' must be provided.",
        ),
        assert(itemCount == null || itemCount >= 0, "itemCount must be >= 0"),
        assert(spacing >= 0, "Spacing must be positive"),
        assert(minItemWidth == null || minItemWidth > 0,
            "minItemWidth must be > 0");

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveProvider.of(context);
    final width = responsive.size.width;
    final config = responsive.config; // ✅ Centralized Config

    // 1. Calculate Delegate Strategy
    SliverGridDelegate delegate;

    if (minItemWidth != null) {
      // Strategy: Auto-Fit (API Data / Dynamic Content)
      final double effectiveMinWidth =
          scaleMinItemWidth ? minItemWidth!.s : minItemWidth!;

      delegate = SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: effectiveMinWidth,
        crossAxisSpacing: spacing.s,
        mainAxisSpacing: runSpacing.s,
        childAspectRatio: childAspectRatio ?? 1.0,
      );
    } else {
      // Strategy: Manual Control (Static UI / Dashboard)
      int crossAxisCount;

      // ✅ Logic covering ALL 6 Tiers based on Config Breakpoints
      if (width < config.watchBreakpoint) {
        // Watch (< 300)
        crossAxisCount = watch ?? 1;
      } else if (width < config.mobileBreakpoint) {
        // Mobile (300 - 600)
        crossAxisCount = mobile ?? 2;
      } else if (width < config.tabletBreakpoint) {
        // Tablet (600 - 900)
        crossAxisCount = tablet ?? 3;
      } else if (width < config.smallDesktopBreakpoint) {
        // Small Desktop (900 - 1200)
        // Fallback: If smallDesktop is not set, try tablet, then default to 4
        crossAxisCount = smallDesktop ?? tablet ?? 4;
      } else if (width < config.desktopBreakpoint) {
        // Desktop (1200 - 1800)
        // Fallback: If desktop is not set, try smallDesktop, then default to 4
        crossAxisCount = desktop ?? smallDesktop ?? 4;
      } else {
        // Large Desktop (> 1800)
        // Fallback: If largeDesktop is not set, try desktop, then default to 5
        crossAxisCount = largeDesktop ?? desktop ?? 5;
      }

      delegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing.s,
        mainAxisSpacing: runSpacing.s,
        childAspectRatio: childAspectRatio ?? 1.0,
      );
    }

    // 2. Prepare Child Delegate
    // Use non-null assertions safely because we asserted mutual exclusivity in constructor
    final SliverChildDelegate childDelegate = itemBuilder != null
        ? SliverChildBuilderDelegate(itemBuilder!, childCount: itemCount!)
        : SliverChildListDelegate(children!);

    // 3. Return Sliver Mode (For CustomScrollView)
    if (useSliver) {
      final sliver = SliverGrid(
        delegate: childDelegate,
        gridDelegate: delegate,
      );
      return padding != null
          ? SliverPadding(padding: padding!, sliver: sliver)
          : sliver;
    }

    // 4. Return Box Mode (Standard GridView)
    else {
      if (itemBuilder != null) {
        return GridView.builder(
          padding: padding ?? EdgeInsets.zero,
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: delegate,
          itemCount: itemCount!,
          itemBuilder: itemBuilder!,
        );
      } else {
        return GridView(
          padding: padding ?? EdgeInsets.zero,
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: delegate,
          children: children!,
        );
      }
    }
  }
}
