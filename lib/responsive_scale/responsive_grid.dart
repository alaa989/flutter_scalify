import 'package:flutter/material.dart';
import '../responsive_scale/responsive_extensions.dart';
import 'scalify_provider.dart';

/// A powerful Grid wrapper supporting Manual & Auto-Fit modes.
class ResponsiveGrid extends StatefulWidget {
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
  final int? smallDesktop;
  final int? desktop;
  final int? largeDesktop;

  // --- Layout Strategy (Auto-Fit) ---
  final double? minItemWidth;
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
        );

  @override
  State<ResponsiveGrid> createState() => _ResponsiveGridState();
}

class _ResponsiveGridState extends State<ResponsiveGrid> {
  SliverGridDelegate? _cachedDelegate;
  double? _lastWidth;
  Object? _lastConfigKey;

  @override
  Widget build(BuildContext context) {
    final responsive = ScalifyProvider.of(context);
    final width = responsive.size.width;
    final config = responsive.config;

    final currentConfigKey = Object.hash(widget.spacing, widget.runSpacing,
        widget.childAspectRatio, widget.minItemWidth, widget.scaleMinItemWidth);

    // Optimization: Cache updated with visual config key
    if (_cachedDelegate == null ||
        _lastWidth != width ||
        _lastConfigKey != currentConfigKey) {
      _lastWidth = width;
      _lastConfigKey = currentConfigKey;

      if (widget.minItemWidth != null) {
        final double effectiveMinWidth = widget.scaleMinItemWidth
            ? widget.minItemWidth!.s
            : widget.minItemWidth!;
        _cachedDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: effectiveMinWidth,
          crossAxisSpacing: widget.spacing.s,
          mainAxisSpacing: widget.runSpacing.s,
          childAspectRatio: widget.childAspectRatio ?? 1.0,
        );
      } else {
        int crossAxisCount;
        if (width < config.watchBreakpoint) {
          crossAxisCount = widget.watch ?? 1;
        } else if (width < config.mobileBreakpoint) {
          crossAxisCount = widget.mobile ?? 2;
        } else if (width < config.tabletBreakpoint) {
          crossAxisCount = widget.tablet ?? 3;
        } else if (width < config.smallDesktopBreakpoint) {
          crossAxisCount = widget.smallDesktop ?? widget.tablet ?? 4;
        } else if (width < config.desktopBreakpoint) {
          crossAxisCount = widget.desktop ?? widget.smallDesktop ?? 4;
        } else {
          crossAxisCount = widget.largeDesktop ?? widget.desktop ?? 5;
        }

        _cachedDelegate = SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: widget.spacing.s,
          mainAxisSpacing: widget.runSpacing.s,
          childAspectRatio: widget.childAspectRatio ?? 1.0,
        );
      }
    }

    final SliverChildDelegate childDelegate = widget.itemBuilder != null
        ? SliverChildBuilderDelegate(widget.itemBuilder!,
            childCount: widget.itemCount!)
        : SliverChildListDelegate(widget.children!);

    if (widget.useSliver) {
      final sliver =
          SliverGrid(delegate: childDelegate, gridDelegate: _cachedDelegate!);
      return widget.padding != null
          ? SliverPadding(padding: widget.padding!, sliver: sliver)
          : sliver;
    } else {
      return GridView.builder(
        padding: widget.padding ?? EdgeInsets.zero,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        gridDelegate: _cachedDelegate!,
        itemCount: widget.itemCount ?? widget.children?.length,
        itemBuilder:
            widget.itemBuilder ?? (context, index) => widget.children![index],
      );
    }
  }
}
