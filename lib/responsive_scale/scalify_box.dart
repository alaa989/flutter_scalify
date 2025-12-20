import 'package:flutter/material.dart';

/// Defines how [ScalifyBox] should scale its content relative to its constraints.
enum ScalifyFit {
  /// Scales content based on the width only (Standard behavior).
  width,

  /// Scales content based on the height only.
  height,

  /// Scales based on the smaller dimension (Best for maintaining aspect ratio inside a box).
  contain,

  /// Scales based on the larger dimension.
  cover,
}

/// A widget that creates a locally scaled environment for its children.
///
/// It allows you to build UI components (like Cards) using a reference design size
/// (e.g., 320x200), and they will scale proportionally to fit within any parent container.
class ScalifyBox extends StatelessWidget {
  /// The design width of this component.
  final double referenceWidth;

  /// The design height of this component (Optional).
  final double? referenceHeight;

  /// How to calculate the scale factor. Defaults to [ScalifyFit.width].
  final ScalifyFit fit;

  /// Builder that gives you access to [LocalScaler] (ls).
  final Widget Function(BuildContext context, LocalScaler ls) builder;

  /// Optional: Alignment of the content if the box is larger than the scaled content.
  final AlignmentGeometry alignment;

  /// Creates a [ScalifyBox].
  const ScalifyBox({
    super.key,
    required this.referenceWidth,
    this.referenceHeight,
    this.fit = ScalifyFit.width,
    this.alignment = Alignment.center,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double currentWidth = constraints.maxWidth;
        double currentHeight = constraints.maxHeight;

        // Safety check for infinite constraints
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

        // Align the content if needed
        return Align(
          alignment: alignment,
          child: builder(context, LocalScaler(finalScale)),
        );
      },
    );
  }
}

/// Helper class to scale values locally within a [ScalifyBox].
class LocalScaler {
  final double _scale;

  /// Creates a [LocalScaler] with a specific scale factor.
  const LocalScaler(this._scale);

  /// Returns the raw scale factor being used.
  double get scaleFactor => _scale;

  // --- Core Scaling ---

  /// Scales a generic number (like spacing or unspecified dimensions).
  double s(num value) => value * _scale;

  /// Scales font size (with limits to prevent it becoming microscopic or huge).
  double fz(num value) => (value * _scale).clamp(4.0, 400.0);

  /// Scales integer values (useful for alpha or precise counts).
  int si(num value) => (value * _scale).round();

  // --- Dimensions & Icons (New Shortcuts) ---

  /// Scales width (same as .s but semantically clearer).
  double w(num value) => value * _scale;

  /// Scales height (same as .s but semantically clearer).
  double h(num value) => value * _scale;

  /// Scales icon size.
  double iz(num value) => value * _scale;

  // --- Spacing Widgets (New Shortcuts) ---

  /// Returns a SizedBox with scaled height.
  SizedBox sbh(num value) => SizedBox(height: value * _scale);

  /// Returns a SizedBox with scaled width.
  SizedBox sbw(num value) => SizedBox(width: value * _scale);

  // --- Padding & Radius Shortcuts ---

  /// EdgeInsets.all
  EdgeInsets p(num value) => EdgeInsets.all(value * _scale);

  /// EdgeInsets.symmetric(horizontal)
  EdgeInsets ph(num value) => EdgeInsets.symmetric(horizontal: value * _scale);

  /// EdgeInsets.symmetric(vertical)
  EdgeInsets pv(num value) => EdgeInsets.symmetric(vertical: value * _scale);

  /// BorderRadius.circular
  BorderRadius br(num value) => BorderRadius.circular(value * _scale);

  /// Radius.circular
  Radius r(num value) => Radius.circular(value * _scale);
}
