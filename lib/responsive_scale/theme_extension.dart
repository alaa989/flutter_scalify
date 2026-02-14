import 'package:flutter/material.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

/// Extension to scale [ThemeData] based on [ResponsiveData] metrics.
extension ScalifyThemeExtension on ThemeData {
  /// Scales the [TextTheme] and [IconTheme] of the current theme.
  /// This ensures that all standard widgets (ListTile, AppBar, etc.)
  /// adapt automatically without manual .fz or .iz calls.
  ThemeData scale(BuildContext context) {
    /// v3.0.0 Improvement: Subscribe only to the 'scale' aspect for performance.
    final double scale =
        ScalifyProvider.of(context, aspect: ScalifyAspect.scale).scaleFactor;
    ScalifyProvider.of(context, aspect: ScalifyAspect.scale).scaleFactor;

    /// Optimization: If scale is 1.0, return the original theme immediately.
    if (scale == 1.0) return this;

    /// Improve TextTheme scaling with fallback colors to prevent the fontSize assertion error.
    final TextTheme scaledTextTheme = textTheme.apply(
      fontSizeFactor: scale,
      displayColor: textTheme.displayLarge?.color,
      bodyColor: textTheme.bodyLarge?.color,
    );

    /// Improvement: Also scale IconThemes for a perfectly consistent UI.
    return copyWith(
      textTheme: scaledTextTheme,
      iconTheme: iconTheme.copyWith(
        size: (iconTheme.size ?? 24.0) * scale,
      ),
      primaryIconTheme: primaryIconTheme.copyWith(
        size: (primaryIconTheme.size ?? 24.0) * scale,
      ),
    );
  }
}
