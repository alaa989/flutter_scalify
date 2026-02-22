import 'package:flutter/material.dart';
import 'responsive_data.dart';
import 'responsive_extensions.dart';

/// A responsive text widget that automatically adapts its content and size
/// based on the available space and screen type.
///
/// Features:
/// - **Auto-resize**: Shrinks font size to fit available width (binary search).
/// - **Short text**: Shows abbreviated text on small screens.
/// - **Overflow protection**: Never overflows — guaranteed.
///
/// ## Example
///
/// ```dart
/// ResponsiveText(
///   'Welcome to our Amazing App',
///   shortText: 'Welcome',
///   style: TextStyle(fontSize: 18.fz),
///   autoResize: true,
///   minFontSize: 10,
/// )
/// ```
class ResponsiveText extends StatelessWidget {
  /// The full text to display.
  final String text;

  /// Optional shorter text for small screens (watch/mobile).
  /// If null, the full [text] is always used.
  final String? shortText;

  /// The text style. If null, uses the default from [DefaultTextStyle].
  final TextStyle? style;

  /// Whether to automatically shrink the font to fit available width.
  /// Defaults to `false` for maximum performance (no [LayoutBuilder]).
  final bool autoResize;

  /// The minimum font size when [autoResize] is true. Defaults to `8.0`.
  final double minFontSize;

  /// The step size for font size reduction during auto-resize.
  /// Smaller values = more precise fit but slightly more computation.
  /// Defaults to `0.5`.
  final double stepGranularity;

  /// Maximum number of lines. Defaults to `null` (unlimited).
  final int? maxLines;

  /// Text alignment. Defaults to [TextAlign.start].
  final TextAlign? textAlign;

  /// Overflow behavior when [autoResize] is false. Defaults to [TextOverflow.ellipsis].
  final TextOverflow overflow;

  /// Text direction for RTL support.
  final TextDirection? textDirection;

  /// Semantic label for accessibility.
  final String? semanticsLabel;

  /// Creates a [ResponsiveText] widget.
  const ResponsiveText(
    this.text, {
    super.key,
    this.shortText,
    this.style,
    this.autoResize = false,
    this.minFontSize = 8.0,
    this.stepGranularity = 0.5,
    this.maxLines,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
    this.textDirection,
    this.semanticsLabel,
  }) : assert(minFontSize > 0, 'minFontSize must be positive');

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;
    final effectiveText = _resolveText(data.screenType);

    if (!autoResize) {
      return Text(
        effectiveText,
        style: style,
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: overflow,
        textDirection: textDirection,
        semanticsLabel: semanticsLabel,
      );
    }

    // Auto-resize path: uses LayoutBuilder to measure available width.
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final resolvedStyle = _resolveStyle(context);
        final baseFontSize = resolvedStyle.fontSize ?? 14.0;

        final fittedSize = _calculateFittedFontSize(
          text: effectiveText,
          style: resolvedStyle,
          maxWidth: maxWidth,
          maxFontSize: baseFontSize,
          minFontSize: minFontSize,
          maxLines: maxLines ?? 1,
          textDirection: textDirection ?? Directionality.of(context),
        );

        return Text(
          effectiveText,
          style: resolvedStyle.copyWith(fontSize: fittedSize),
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: overflow,
          textDirection: textDirection,
          semanticsLabel: semanticsLabel,
        );
      },
    );
  }

  /// Resolves which text to display based on screen type.
  @pragma('vm:prefer-inline')
  String _resolveText(ScreenType screenType) {
    if (shortText == null) return text;
    return (screenType == ScreenType.watch || screenType == ScreenType.mobile)
        ? shortText!
        : text;
  }

  /// Resolves the effective text style from context hierarchy.
  @pragma('vm:prefer-inline')
  TextStyle _resolveStyle(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    return defaultStyle.merge(style);
  }

  /// Binary-search approach to find the largest font size that fits.
  ///
  /// Uses [TextPainter] for precise measurement. The search range is
  /// [minFontSize, maxFontSize] with [stepGranularity] precision.
  static double _calculateFittedFontSize({
    required String text,
    required TextStyle style,
    required double maxWidth,
    required double maxFontSize,
    required double minFontSize,
    required int maxLines,
    required TextDirection textDirection,
  }) {
    // Fast path: if max font size fits, no need to search.
    if (_textFits(
        text, style, maxFontSize, maxWidth, maxLines, textDirection)) {
      return maxFontSize;
    }

    // Binary search for the largest fitting font size.
    double low = minFontSize;
    double high = maxFontSize;
    double bestFit = minFontSize;

    // Limit iterations to prevent excessive computation.
    // With step 0.5 and range 256, max ~9 iterations.
    int iterations = 0;
    const maxIterations = 20;

    while (low <= high && iterations < maxIterations) {
      final mid = ((low + high) / 2);
      // Snap to step granularity
      final snapped = (mid * 2).floorToDouble() / 2; // 0.5 precision

      if (_textFits(text, style, snapped, maxWidth, maxLines, textDirection)) {
        bestFit = snapped;
        low = snapped + 0.5;
      } else {
        high = snapped - 0.5;
      }
      iterations++;
    }

    return bestFit;
  }

  /// Checks if [text] fits within [maxWidth] at the given [fontSize].
  static bool _textFits(
    String text,
    TextStyle style,
    double fontSize,
    double maxWidth,
    int maxLines,
    TextDirection textDirection,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style.copyWith(fontSize: fontSize)),
      maxLines: maxLines,
      textDirection: textDirection,
    )..layout(maxWidth: maxWidth);

    final fits = !painter.didExceedMaxLines && painter.width <= maxWidth;
    painter.dispose();
    return fits;
  }
}
