import 'package:flutter/material.dart';

/// Defines how [ScalifyBox] should scale its content relative to its constraints.
enum ScalifyFit {
  /// Scales content based on the width only (Standard behavior).
  /// Best for lists, rows, and standard layouts.
  width,

  /// Scales content based on the height only.
  /// Best for sidebars or horizontal scrolling strips.
  height,

  /// Scales based on the smaller dimension (Width vs Height).
  /// This ensures content ALWAYS fits inside the box without overflowing,
  /// regardless of the Aspect Ratio (16:9, 4:3, 1:1).
  /// Best for Grids and Cards with changing Aspect Ratios.
  contain,

  /// Scales based on the larger dimension.
  cover,
}

class ScalifyBox extends StatelessWidget {
  /// The design width of this component.
  final double referenceWidth;

  /// The design height of this component (Optional).
  /// Required only if using [ScalifyFit.height], [ScalifyFit.contain], or [ScalifyFit.cover].
  final double? referenceHeight;

  /// How to calculate the scale factor. Defaults to [ScalifyFit.width].
  final ScalifyFit fit;

  final Widget Function(BuildContext context, LocalScaler ls) builder;

  const ScalifyBox({
    super.key,
    required this.referenceWidth,
    this.referenceHeight,
    this.fit = ScalifyFit.width,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double currentWidth = constraints.maxWidth;
        double currentHeight = constraints.maxHeight;

        // Safety check for infinite constraints (e.g. inside ScrollView without limits)
        if (!currentWidth.isFinite) {
          currentWidth = MediaQuery.of(context).size.width;
        }
        if (!currentHeight.isFinite) {
          currentHeight = MediaQuery.of(context).size.height;
        }

        final double safeRefW = referenceWidth > 0 ? referenceWidth : 1.0;
        final double safeRefH = (referenceHeight ?? safeRefW) > 0
            ? (referenceHeight ?? safeRefW)
            : 1.0;

        double scaleX = currentWidth / safeRefW;
        double scaleY = currentHeight / safeRefH;

        double finalScale;

        switch (fit) {
          case ScalifyFit.width:
            finalScale = scaleX;
            break;
          case ScalifyFit.height:
            finalScale = scaleY;
            break;
          case ScalifyFit.contain:
            finalScale = (scaleX < scaleY) ? scaleX : scaleY;
            break;
          case ScalifyFit.cover:
            finalScale = (scaleX > scaleY) ? scaleX : scaleY;
            break;
        }

        return builder(context, LocalScaler(finalScale));
      },
    );
  }
}

class LocalScaler {
  final double _scale;

  LocalScaler(this._scale);

  double get scaleFactor => _scale;

  double s(double value) => value * _scale;

  double fz(double value) => (value * _scale).clamp(4.0, 400.0);

  EdgeInsets p(double value) => EdgeInsets.all(value * _scale);
  Radius r(double value) => Radius.circular(value * _scale);
  BorderRadius br(double value) => BorderRadius.circular(value * _scale);
}
