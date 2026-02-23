import 'package:flutter/material.dart';
import 'responsive_extensions.dart';

/// A widget that builds different layouts based on the screen orientation.
///
/// Displays [portrait] when the screen height exceeds the width, and
/// [landscape] when the width exceeds the height.
///
/// ## Performance Design
/// - Single comparison per build (`width > height`) — O(1)
/// - No [LayoutBuilder] — reads size from [ResponsiveData] via [InheritedWidget]
/// - Zero allocation — simply returns one of two pre-built child widgets
///
/// ## Example
///
/// ```dart
/// ResponsiveLayout(
///   portrait: SingleColumnLayout(),
///   landscape: TwoColumnLayout(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  /// The widget to display in portrait orientation (height > width).
  final Widget portrait;

  /// The widget to display in landscape orientation (width > height).
  final Widget landscape;

  /// Creates a [ResponsiveLayout].
  const ResponsiveLayout({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;
    final bool isLandscape = data.size.width > data.size.height;

    return isLandscape ? landscape : portrait;
  }
}
