import 'package:flutter/material.dart';
import 'responsive_data.dart';
import 'responsive_extensions.dart';

/// A builder widget that ensures live responsive updates for its subtree.
///
/// Use [ScalifyBuilder] when you want your UI (text, icons, spacing) to
/// adapt instantly while resizing the app window on Desktop or Web.
/// It creates a formal subscription to the responsive state, forcing a
/// rebuild with the latest scaled values.
class ScalifyBuilder extends StatelessWidget {
  /// A builder function that provides the current [ResponsiveData].
  final Widget Function(BuildContext context, ResponsiveData data) builder;

  /// Creates a [ScalifyBuilder] to enable live scaling.
  const ScalifyBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    // This line creates the active subscription to the provider
    final data = context.responsiveData;

    // Executing the builder function with fresh data
    return builder(context, data);
  }
}
