import 'package:flutter/material.dart';
import 'scalify_provider.dart';

/// Extension to scale [ThemeData] based on [ResponsiveData] metrics.
extension ScalifyThemeExtension on ThemeData {
  ThemeData scale(BuildContext context) {
    final double scale =
        ScalifyProvider.of(context, aspect: ScalifyAspect.scale).scaleFactor;

    if (scale == 1.0) return this;

    final TextTheme baseTextTheme = textTheme.merge(
      Typography.material2021().englishLike,
    );

    final TextTheme scaledTextTheme = baseTextTheme.apply(
      fontSizeFactor: scale,
      displayColor: textTheme.displayLarge?.color,
      bodyColor: textTheme.bodyLarge?.color,
    );

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
