import 'package:flutter/material.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

/// A function signature for building responsive widgets.
typedef ResponsiveWidgetBuilder = Widget Function(
    BuildContext context, ResponsiveData data);

/// A builder widget that provides [ResponsiveData] to its builder function.
/// Useful for creating complex custom responsive logic inline.
class ResponsiveBuilder extends StatelessWidget {
  /// The builder function that receives [ResponsiveData].
  final ResponsiveWidgetBuilder builder;

  /// Creates a [ResponsiveBuilder].
  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, context.responsiveData);
  }
}
