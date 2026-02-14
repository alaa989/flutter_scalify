import 'package:flutter/material.dart';
import 'container_query.dart';

/// A simplified declarative wrapper around [ContainerQuery].
/// It allows you to specify different widgets for different container sizes
/// without writing if/else logic.
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
        // 🔥 Optimization: Use array lookup for CPU pipeline efficiency.
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
