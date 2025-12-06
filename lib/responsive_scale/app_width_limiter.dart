import 'package:flutter/material.dart';

/// A widget that limits the maximum width of its child.
/// Useful for web and desktop applications to prevent content from stretching too wide.
class AppWidthLimiter extends StatelessWidget {
  /// The child widget to be constrained.
  final Widget child;

  /// The maximum width allowed for the content.
  final double maxWidth;

  /// The background color of the outer container.
  final Color? backgroundColor;

  /// Padding applied horizontally when the screen is wider than [maxWidth].
  final double horizontalPadding;

  /// Creates an [AppWidthLimiter].
  const AppWidthLimiter({
    super.key,
    required this.child,
    this.maxWidth = 1000.0,
    this.backgroundColor,
    this.horizontalPadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double screenWidth = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : MediaQuery.maybeOf(context)?.size.width ?? 0.0;

      if (screenWidth > maxWidth) {
        return Container(
          color: backgroundColor,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        );
      }

      return child;
    });
  }
}
