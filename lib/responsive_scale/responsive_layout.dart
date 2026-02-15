import 'package:flutter/material.dart';
import 'responsive_extensions.dart';

/// A widget that builds different layouts based on the screen orientation.
class ResponsiveLayout extends StatelessWidget {
  final Widget portrait;
  final Widget landscape;

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
