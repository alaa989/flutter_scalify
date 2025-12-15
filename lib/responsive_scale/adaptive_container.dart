import 'package:flutter/material.dart';
import 'container_query.dart';

/// A simplified declarative wrapper around [ContainerQuery].
/// It allows you to specify different widgets for different container sizes
/// without writing if/else logic.
///
/// Example:
/// AdaptiveContainer(
///   xs: Icon(Icons.menu),      // Show icon on very small width
///   md: Text("Menu"),          // Show text on medium width
///   lg: Row(...),              // Show full row on large width
/// )
class AdaptiveContainer extends StatelessWidget {
  // --- The Widgets for each Tier ---
  /// The default widget (Extra Small). Required as a fallback.
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

  // --- Configuration ---
  /// Custom breakpoints to define when to switch.
  /// If null, default logic applies.
  /// Example: [200, 500, 800]
  final List<double>? breakpoints;

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
        // Fallback Logic (Cascading)
        // If a larger tier is not provided, use the nearest smaller one.

        if (query.tier == QueryTier.xxl && xxl != null) return xxl!;
        if (query.tier.index >= QueryTier.xl.index && xl != null) return xl!;
        if (query.tier.index >= QueryTier.lg.index && lg != null) return lg!;
        if (query.tier.index >= QueryTier.md.index && md != null) return md!;
        if (query.tier.index >= QueryTier.sm.index && sm != null) return sm!;

        // Default to XS (Always required)
        return xs;
      },
    );
  }
}
