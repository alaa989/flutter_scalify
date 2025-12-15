import 'package:flutter/material.dart';

/// A powerful widget that enables "Component-Driven Design".
/// It rebuilds its child based on the parent container's size, not the screen size.
///
/// Use cases:
/// - Cards that change layout when placed in a narrow sidebar vs wide main area.
/// - Reusable components that adapt to their surroundings.
class ContainerQuery extends StatelessWidget {
  /// The builder that provides layout data based on current constraints.
  final Widget Function(BuildContext context, ContainerQueryData query) builder;

  /// Custom breakpoints to categorize size into Tiers (XS, SM, MD, LG, XL).
  /// Default logic will be applied if null.
  /// Example: `[200, 400, 600]`
  /// - Width `< 200` -> XS
  /// - `200 <= Width < 400` -> SM
  /// - ...
  final List<double>? breakpoints;

  const ContainerQuery({
    super.key,
    required this.builder,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 1. Safety Check: Handle unbounded constraints (e.g., inside ScrollView)
        // We fallback to 0.0 to allow logic checks to proceed without crashing.
        final double width =
            constraints.hasBoundedWidth ? constraints.maxWidth : 0.0;
        final double height =
            constraints.hasBoundedHeight ? constraints.maxHeight : 0.0;

        // 2. Determine QueryTier based on breakpoints
        QueryTier tier = QueryTier.xs;

        if (breakpoints != null && breakpoints!.isNotEmpty) {
          // Ensure breakpoints are sorted for correct logic
          final sortedBreaks = List<double>.from(breakpoints!)..sort();

          // Logic: Find the highest tier threshold passed
          for (int i = 0; i < sortedBreaks.length; i++) {
            if (width >= sortedBreaks[i]) {
              if (i == 0) {
                tier = QueryTier.sm;
              } else if (i == 1) {
                tier = QueryTier.md;
              } else if (i == 2) {
                tier = QueryTier.lg;
              } else if (i == 3) {
                tier = QueryTier.xl;
              } else {
                tier = QueryTier.xxl;
              }
            } else {
              // Optimization: Break early if width is smaller than current breakpoint
              break;
            }
          }
        }

        // 3. Create Data Object
        final queryData = ContainerQueryData(
          width: width,
          height: height,
          tier: tier,
        );

        return builder(context, queryData);
      },
    );
  }
}

/// Data holding the exact size and the calculated semantic Tier.
class ContainerQueryData {
  final double width;
  final double height;
  final QueryTier tier;

  const ContainerQueryData({
    required this.width,
    required this.height,
    required this.tier,
  });

  /// Returns true if the container width is strictly less than [value].
  bool isLessThan(double value) => width < value;

  /// Returns true if the container width is greater than or equal to [value].
  bool isAtLeast(double value) => width >= value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContainerQueryData &&
        other.width == width &&
        other.height == height &&
        other.tier == tier;
  }

  @override
  int get hashCode => Object.hash(width, height, tier);
}

/// Semantic size categories for the container.
enum QueryTier {
  xs, // Extra Small (Below 1st breakpoint)
  sm, // Small (Above 1st breakpoint)
  md, // Medium (Above 2nd breakpoint)
  lg, // Large (Above 3rd breakpoint)
  xl, // Extra Large (Above 4th breakpoint)
  xxl // Double Extra Large (Above 5th breakpoint)
}
