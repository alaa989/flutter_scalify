import 'package:flutter/material.dart';
import 'scalify_config.dart';
import 'scalify_provider.dart';

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
  List<double>? _sortedBreaks;

  @override
  void initState() {
    super.initState();
    _prepareBreaks();
  }

  @override
  void didUpdateWidget(covariant ContainerQuery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.breakpoints != oldWidget.breakpoints) {
      _prepareBreaks();
    }
  }

  void _prepareBreaks() {
    _sortedBreaks = widget.breakpoints == null
        ? null
        : (List<double>.from(widget.breakpoints!)..sort());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final double height = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;

        QueryTier tier = QueryTier.xs;

        if (_sortedBreaks != null && _sortedBreaks!.isNotEmpty) {
          for (int i = 0; i < _sortedBreaks!.length; i++) {
            if (width >= _sortedBreaks![i]) {
              tier = QueryTier
                  .values[(i + 1).clamp(0, QueryTier.values.length - 1)];
            } else {
              break;
            }
          }
        }

        final current =
            ContainerQueryData(width: width, height: height, tier: tier);
        final cfg = _getConfig(context);
        final tol = cfg.rebuildWidthPxThreshold;

        final bool widthChanged =
            _prev == null ? true : (current.width - _prev!.width).abs() >= tol;
        final bool tierChanged =
            _prev == null ? true : _prev!.tier != current.tier;

        if ((widthChanged || tierChanged) && widget.onChanged != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) widget.onChanged?.call(_prev ?? current, current);
          });
        }
        _prev = current;

        return widget.builder(context, current);
      },
    );
  }

  ScalifyConfig _getConfig(BuildContext context) {
    try {
      return ScalifyProvider.of(context).config;
    } catch (_) {
      return const ScalifyConfig();
    }
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
