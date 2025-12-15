import 'package:flutter/material.dart';
import '../responsive_scale/responsive_extensions.dart';
import '../responsive_scale/responsive_provider.dart';
import '../responsive_scale/responsive_data.dart';

/// A smart widget that switches between [Row] and [Column].
class ResponsiveFlex extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  // --- Control Logic ---
  final double? breakpoint;
  final ScreenType? switchOn;

  // --- RTL Support ---
  final bool flipOnRtl;

  // --- Alignment Logic ---
  final MainAxisAlignment? rowMainAxisAlignment;
  final MainAxisAlignment? colMainAxisAlignment;
  final CrossAxisAlignment? rowCrossAxisAlignment;
  final CrossAxisAlignment? colCrossAxisAlignment;

  // --- Size Logic (FIXED) ---
  final MainAxisSize mainAxisSize;

  const ResponsiveFlex({
    super.key,
    required this.children,
    this.spacing = 0,
    this.breakpoint,
    this.switchOn,
    this.flipOnRtl = false,
    this.rowMainAxisAlignment,
    this.colMainAxisAlignment,
    this.rowCrossAxisAlignment,
    this.colCrossAxisAlignment,
    this.mainAxisSize = MainAxisSize.max, // ✅ Default to max
  }) : assert(spacing >= 0, "Spacing must be >= 0");

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveProvider.of(context);
    final width = responsive.size.width;
    final config = responsive.config;

    // 1. Determine Layout Mode
    bool isColumn = false;

    if (breakpoint != null) {
      isColumn = width < breakpoint!;
    } else if (switchOn != null) {
      isColumn = _isDeviceSmallerOrEqual(responsive.screenType, switchOn!);
    } else {
      isColumn = width < config.tabletBreakpoint;
    }

    // 2. Handle RTL Logic
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final effectiveChildren =
        (isRtl && flipOnRtl) ? children.reversed.toList() : children;

    // 3. Optimized Widget Building with Spacing
    if (spacing == 0) {
      return _buildFlex(isColumn, effectiveChildren);
    }

    final Widget spacer =
        isColumn ? SizedBox(height: spacing.s) : SizedBox(width: spacing.s);

    final spacedChildren = List<Widget>.generate(
      effectiveChildren.length * 2 - 1,
      (index) {
        if (index.isEven) return effectiveChildren[index ~/ 2];
        return spacer;
      },
    );

    return _buildFlex(isColumn, spacedChildren);
  }

  Widget _buildFlex(bool isColumn, List<Widget> children) {
    return Flex(
      direction: isColumn ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: isColumn
          ? (colMainAxisAlignment ?? MainAxisAlignment.start)
          : (rowMainAxisAlignment ?? MainAxisAlignment.start),
      crossAxisAlignment: isColumn
          ? (colCrossAxisAlignment ?? CrossAxisAlignment.center)
          : (rowCrossAxisAlignment ?? CrossAxisAlignment.center),
      mainAxisSize: mainAxisSize, // ✅ Fixed here
      children: children,
    );
  }

  bool _isDeviceSmallerOrEqual(ScreenType current, ScreenType limit) {
    return current.index <= limit.index;
  }
}
