import 'package:flutter/material.dart';
import 'responsive_data.dart';
import 'responsive_extensions.dart';

/// A responsive image widget that displays different images based on
/// the current screen type, optimizing memory usage and visual quality.
///
/// ## Performance Design
/// - Only one [ImageProvider] is resolved per build (no unused images loaded)
/// - Uses [Image] widget with `gaplessPlayback: true` for smooth transitions
/// - Optional `cacheWidth`/`cacheHeight` via [autoOptimize] for memory savings
/// - Fallback chain: desktop → tablet → mobile ensures no null images
///
/// ## Example
///
/// ```dart
/// ResponsiveImage(
///   mobile: AssetImage('assets/banner_sm.webp'),
///   tablet: AssetImage('assets/banner_md.webp'),
///   desktop: AssetImage('assets/banner_lg.webp'),
///   fit: BoxFit.cover,
///   height: 200.s,
/// )
/// ```
class ResponsiveImage extends StatelessWidget {
  /// The image to display on mobile/watch screens. **Required** as the fallback.
  final ImageProvider mobile;

  /// Optional image for tablet screens. Falls back to [mobile].
  final ImageProvider? tablet;

  /// Optional image for desktop/large desktop. Falls back to [tablet] → [mobile].
  final ImageProvider? desktop;

  /// How to inscribe the image into the space. Default: [BoxFit.cover].
  final BoxFit fit;

  /// Optional fixed width for the image container.
  final double? width;

  /// Optional fixed height for the image container.
  final double? height;

  /// Alignment within the container. Default: [Alignment.center].
  final AlignmentGeometry alignment;

  /// Widget to show while the image is loading.
  final Widget? placeholder;

  /// Widget to show if the image fails to load.
  final Widget? errorWidget;

  /// Whether to automatically resize the decoded image to match the
  /// display size, reducing memory usage. Default: `false`.
  ///
  /// When `true`, uses [ResizeImage] to decode at the exact display size.
  final bool autoOptimize;

  /// Border radius for the image. If null, no clipping.
  final BorderRadius? borderRadius;

  /// Color filter to apply on the image (e.g., for overlays).
  final Color? color;

  /// Blend mode for [color]. Default: [BlendMode.srcIn].
  final BlendMode? colorBlendMode;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Creates a [ResponsiveImage].
  const ResponsiveImage({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
    this.autoOptimize = false,
    this.borderRadius,
    this.color,
    this.colorBlendMode,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;
    final provider = _resolveProvider(data.screenType);

    // Optionally wrap with ResizeImage for memory optimization
    final effectiveProvider = autoOptimize && (width != null || height != null)
        ? ResizeImage(
            provider,
            width: width?.toInt(),
            height: height?.toInt(),
          )
        : provider;

    Widget image = Image(
      image: effectiveProvider,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment as Alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      gaplessPlayback: true, // Smooth transition when provider changes
      frameBuilder: placeholder != null ? _frameBuilder : null,
      errorBuilder: errorWidget != null ? _errorBuilder : null,
    );

    // Apply border radius if specified
    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  /// Resolves the correct [ImageProvider] based on screen type.
  /// Falls back through: desktop → tablet → mobile (always available).
  @pragma('vm:prefer-inline')
  ImageProvider _resolveProvider(ScreenType screenType) {
    switch (screenType) {
      case ScreenType.largeDesktop:
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenType.smallDesktop:
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.mobile:
      case ScreenType.watch:
        return mobile;
    }
  }

  /// Frame builder for placeholder support.
  Widget _frameBuilder(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (wasSynchronouslyLoaded || frame != null) return child;
    return placeholder!;
  }

  /// Error builder for error widget support.
  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return errorWidget!;
  }
}
