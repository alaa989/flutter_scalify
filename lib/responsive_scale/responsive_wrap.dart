import 'package:flutter/material.dart';
import 'responsive_extensions.dart';

/// A smart wrapping widget that displays children horizontally and
/// automatically wraps to the next line when space runs out.
///
/// Unlike [ResponsiveFlex] which switches entirely between [Row] and [Column],
/// [ResponsiveWrap] wraps items **line by line** — perfect for chips, tags,
/// and button groups.
///
/// ## Performance Design
/// - Uses [Wrap] internally (Flutter's optimized layout algorithm)
/// - Spacing values are scaled via `.s` only once per build
/// - No [LayoutBuilder] needed — Flutter's Wrap handles overflow natively
///
/// ## Example
///
/// ```dart
/// ResponsiveWrap(
///   spacing: 12,
///   runSpacing: 8,
///   children: [
///     FilterChip(label: Text('All')),
///     FilterChip(label: Text('Clothes')),
///     FilterChip(label: Text('Electronics')),
///     FilterChip(label: Text('Shoes')),
///   ],
/// )
/// ```
class ResponsiveWrap extends StatelessWidget {
  /// The children to layout.
  final List<Widget> children;

  /// Horizontal spacing between children (scaled via `.s`).
  final double spacing;

  /// Vertical spacing between lines (scaled via `.s`).
  final double runSpacing;

  /// Alignment of children along the main axis.
  final WrapAlignment alignment;

  /// Alignment of children along the cross axis within each run.
  final WrapCrossAlignment crossAxisAlignment;

  /// Alignment of runs within the overall wrap.
  final WrapAlignment runAlignment;

  /// The direction in which children are laid out.
  final Axis direction;

  /// Whether to scale [spacing] and [runSpacing] using Scalify.
  /// Set to `false` if you want fixed pixel values. Default: `true`.
  final bool scaleSpacing;

  /// Optional padding around the entire wrap.
  final EdgeInsetsGeometry? padding;

  /// Creates a [ResponsiveWrap].
  const ResponsiveWrap({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.center,
    this.runAlignment = WrapAlignment.start,
    this.direction = Axis.horizontal,
    this.scaleSpacing = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Scale spacing once per build — O(1)
    final double effectiveSpacing = scaleSpacing ? spacing.s : spacing;
    final double effectiveRunSpacing = scaleSpacing ? runSpacing.s : runSpacing;

    final wrap = Wrap(
      spacing: effectiveSpacing,
      runSpacing: effectiveRunSpacing,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      runAlignment: runAlignment,
      direction: direction,
      children: children,
    );

    if (padding != null) {
      return Padding(padding: padding!, child: wrap);
    }
    return wrap;
  }
}
