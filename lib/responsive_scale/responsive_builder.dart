import 'package:flutter/material.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

/// A function signature for building responsive widgets.
typedef ResponsiveWidgetBuilder = Widget Function(
    BuildContext context, ResponsiveData data);

/// The primary builder widget for creating responsive layouts.
///
/// Rebuilds its child whenever [ResponsiveData] changes (e.g., screen resize,
/// orientation change), providing fresh scaling values to the [builder].
///
/// This is the recommended way to build custom responsive logic inline:
/// ```dart
/// ResponsiveBuilder(
///   builder: (context, data) => Text(
///     'Scale: ${data.scaleFactor.toStringAsFixed(2)}',
///     style: TextStyle(fontSize: 14 * data.scaleFactor),
///   ),
/// )
/// ```
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
