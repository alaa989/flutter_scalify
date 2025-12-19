import 'package:flutter/material.dart';
import 'scalify_provider.dart';
import 'scalify_config.dart';

/// A widget that limits the maximum width of its child AND resets the responsive scaling logic.
///
/// This is crucial for large screens (Web/Desktop). It ensures that if the UI stops stretching
/// at [maxWidth], the font sizes and icons also stop growing, preventing gigantic elements.
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
      // 1. Get safe screen width
      final double screenWidth = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : MediaQuery.maybeOf(context)?.size.width ?? 0.0;

      // 2. PERFORMANCE CHECK:
      // If screen is smaller than limit (Mobile/Tablet), return child immediately.
      // This ensures ZERO overhead for 90% of users.
      if (screenWidth <= maxWidth) {
        return child;
      }

      // 3. DESKTOP/WEB LOGIC:
      // Screen is huge. We need to clamp both Layout AND Scaling.

      // A. Retrieve existing config to maintain user settings (designWidth, etc.)
      // We try to get it from the nearest provider, or fallback to default.
      ScalifyConfig currentConfig;
      try {
        currentConfig = ScalifyProvider.of(context).config;
      } catch (_) {
        currentConfig = const ScalifyConfig();
      }

      return Container(
        color: backgroundColor,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),

        // B. Visually constrain the child width
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),

          // C. LOGIC OVERRIDE:
          // We inject a modified MediaQuery.
          // We tell the subtree: "The screen width is exactly [maxWidth]".
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: Size(maxWidth, MediaQuery.of(context).size.height),
            ),

            // D. SCALE RESET:
            // We inject a NEW ScalifyProvider here.
            // It reads the modified MediaQuery above and recalculates .s/.fz
            // based on [maxWidth] instead of the huge screen width.
            child: Builder(
              builder: (innerContext) {
                return ScalifyProvider(
                  config: currentConfig, // Pass through the original config
                  child: child,
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
