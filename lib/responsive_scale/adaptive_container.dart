import 'package:flutter/material.dart';
import 'container_query.dart';

/// A simplified declarative wrapper around [ContainerQuery] that displays
/// different widgets based on the parent container's size tier.
///
/// Unlike screen-based breakpoints, [AdaptiveContainer] responds to the
/// **parent's actual constraints**, making it ideal for reusable components
/// that may appear in different-sized containers.
///
/// ## Performance Design
/// - Uses [ContainerQuery] internally (single [LayoutBuilder] per instance)
/// - Widget selection via array lookup — O(1) fallback chain
/// - No extra allocations — the widget array is created once per build
///
/// ## Fallback Behavior
/// If a widget for the current tier is `null`, falls back to the nearest
/// smaller tier: `xxl → xl → lg → md → sm → xs` (always available).
///
/// ## Example
///
/// ```dart
/// AdaptiveContainer(
///   breakpoints: [300, 500, 700, 900, 1200],
///   xs: CompactProductCard(),
///   md: MediumProductCard(),
///   lg: ExpandedProductCard(),
/// )
/// ```
class AdaptiveContainer extends StatelessWidget {
  /// The default widget (Extra Small). **Required** as the fallback.
  final Widget xs;

  /// Optional: Widget for Small containers.
  final Widget? sm;

  /// Optional: Widget for Medium containers.
  final Widget? md;

  /// Optional: Widget for Large containers.
  final Widget? lg;

  /// Optional: Widget for Extra Large containers.
  final Widget? xl;

  /// Optional: Widget for Double Extra Large containers.
  final Widget? xxl;

  /// Custom breakpoints to define when to switch tiers.
  /// Must contain up to 5 ascending values mapping to sm/md/lg/xl/xxl.
  /// If null, the tier is always [QueryTier.xs].
  final List<double>? breakpoints;

  /// Creates an [AdaptiveContainer].
  const AdaptiveContainer({
    super.key,
    required this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerQuery(
      breakpoints: breakpoints,
      builder: (context, query) {
        // Optimization: Use array lookup for CPU pipeline efficiency.
        final widgets = <Widget?>[xs, sm, md, lg, xl, xxl];

        for (int i = query.tier.index; i >= 0; i--) {
          final w = widgets[i];
          if (w != null) return w;
        }

        return xs;
      },
    );
  }
}
