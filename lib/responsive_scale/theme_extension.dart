import 'package:flutter/material.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

extension ScalifyThemeExtension on ThemeData {
  ThemeData scale(BuildContext context) {
    final double scale = context.responsiveData.scaleFactor;

    if (scale == 1.0) return this;

    final TextTheme scaledTextTheme = textTheme.apply(
      fontSizeFactor: scale,
      displayColor: textTheme.displayLarge?.color,
      bodyColor: textTheme.bodyLarge?.color,
    );

    return copyWith(textTheme: scaledTextTheme);
  }
}
