import 'package:flutter/material.dart';
import 'scalify_provider.dart';

/// Limits the effective content width and resets scaling for large screens.
///
/// On screens wider than [maxWidth], this widget:
/// 1. Centers the content with a [ConstrainedBox].
/// 2. **Overrides [MediaQuery]** in the subtree, capping `size.width`
///    to [maxWidth]. This causes any child reading `MediaQuery.sizeOf`
///    to see the constrained width, ensuring scaling stays consistent.
/// 3. Wraps the subtree in a new [ScalifyProvider] so that all responsive
///    extensions (`.w`, `.h`, `.fz`, etc.) recalculate based on the
///    capped width.
/// 4. Uses [RepaintBoundary] to isolate the content paint — significantly
///    reducing paint cost during rapid Desktop/Web window resizing.
///
/// If [minWidth] is set (or [ScalifyConfig.minWidth] > 0), the content
/// will horizontally scroll rather than shrink below that threshold.
///
/// ## Example
/// ```dart
/// AppWidthLimiter(
///   maxWidth: 1200,
///   minWidth: 360,
///   child: MyPageContent(),
/// )
/// ```
class AppWidthLimiter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final Color? backgroundColor;
  final double horizontalPadding;
  final double? minWidth;

  const AppWidthLimiter({
    super.key,
    required this.child,
    this.maxWidth = 1000.0,
    this.backgroundColor,
    this.horizontalPadding = 16.0,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Optimization: Use sizeOf to only listen to size changes.
    final mediaSize = MediaQuery.sizeOf(context);

    // Optimization: Access config via specific aspect to prevent unnecessary rebuilds.
    final cfg = ScalifyProvider.of(context, aspect: ScalifyAspect.scale).config;
    final limit = minWidth ?? cfg.minWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : mediaSize.width;

        Widget content = child;

        /// Scroll only when needed.
        if (limit > 0 && width < limit) {
          content = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(width: limit, child: child),
          );
        }

        /// Standard case - Small screens.
        if (width <= maxWidth) {
          return content;
        }

        return ColoredBox(
          color: backgroundColor ?? Colors.transparent,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),

                /// 🔥 RepaintBoundary significantly reduces paint cost during resize.
                child: RepaintBoundary(
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      size: Size(maxWidth, mediaSize.height),
                    ),
                    child: ScalifyProvider(
                      config: cfg,
                      child: content,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
