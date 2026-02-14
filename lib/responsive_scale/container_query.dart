import 'package:flutter/material.dart';
import 'package:flutter_scalify/responsive_scale/scalify_config.dart';
import 'package:flutter_scalify/responsive_scale/scalify_provider.dart';

/// Semantic size categories for the container.
enum QueryTier { xs, sm, md, lg, xl, xxl }

/// Rebuilds its child based on the parent container's size.
class ContainerQuery extends StatefulWidget {
  /// The builder function that receives [ContainerQueryData].
  final Widget Function(BuildContext context, ContainerQueryData query) builder;

  /// Custom breakpoints to categorize size into Tiers.
  final List<double>? breakpoints;

  /// Callback triggered when the calculated tier or size changes.
  final void Function(ContainerQueryData previous, ContainerQueryData current)?
      onChanged;

  const ContainerQuery({
    super.key,
    required this.builder,
    this.breakpoints,
    this.onChanged,
  });

  @override
  State<ContainerQuery> createState() => _ContainerQueryState();
}

class _ContainerQueryState extends State<ContainerQuery> {
  ContainerQueryData? _prev;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width =
            constraints.hasBoundedWidth ? constraints.maxWidth : 0.0;
        final double height =
            constraints.hasBoundedHeight ? constraints.maxHeight : 0.0;

        QueryTier tier = QueryTier.xs;

        if (widget.breakpoints != null && widget.breakpoints!.isNotEmpty) {
          final sortedBreaks = List<double>.from(widget.breakpoints!)..sort();
          for (int i = 0; i < sortedBreaks.length; i++) {
            if (width >= sortedBreaks[i]) {
              tier = QueryTier.values[(i + 1) < QueryTier.values.length
                  ? (i + 1)
                  : QueryTier.values.length - 1];
            } else {
              break;
            }
          }
        }

        final current =
            ContainerQueryData(width: width, height: height, tier: tier);

// احصل على tolerance من config (fallback إذا لم يوجد Provider)
        final cfg = (() {
          try {
            return ScalifyProvider.of(context).config;
          } catch (_) {
            return const ScalifyConfig();
          }
        })();
        final tol = cfg.rebuildWidthPxThreshold;

// استدعاء onChanged فقط إذا تغيرت الفئة (tier) أو الفرق أكبر من tolerance
        final bool widthChanged =
            _prev == null ? true : (_prev!.width - current.width).abs() >= tol;
        final bool heightChanged = _prev == null
            ? true
            : (_prev!.height - current.height).abs() >= tol;
        final bool tierChanged =
            _prev == null ? true : _prev!.tier != current.tier;

        if ((widthChanged || heightChanged || tierChanged) &&
            widget.onChanged != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) widget.onChanged?.call(_prev ?? current, current);
          });
        }
        _prev = current;

        return widget.builder(context, current);
      },
    );
  }
}

/// Data holding the exact size and the calculated semantic [QueryTier].
class ContainerQueryData {
  final double width;
  final double height;
  final QueryTier tier;

  const ContainerQueryData({
    required this.width,
    required this.height,
    required this.tier,
  });

  bool isLessThan(double value) => width < value;
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

  /// Whether the container is considered mobile size.
  bool get isMobile => tier == QueryTier.xs || tier == QueryTier.sm;

  /// Whether the container is considered tablet size.
  bool get isTablet => tier == QueryTier.md;

  /// Whether the container is considered desktop size.
  bool get isDesktop => tier.index >= QueryTier.lg.index;
}
