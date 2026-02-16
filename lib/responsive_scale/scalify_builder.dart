import 'package:flutter_scalify/flutter_scalify.dart';

/// A builder widget that ensures live responsive updates for its subtree.
///
/// Use [ScalifyBuilder] when you want your UI (text, icons, spacing) to
/// adapt instantly while resizing the app window on Desktop or Web.
/// It creates a formal subscription to the responsive state, forcing a
/// rebuild with the latest scaled values.
///
/// **Deprecated**: Use [ResponsiveBuilder] instead, which provides the same
/// functionality. [ScalifyBuilder] will be removed in a future major version.
@Deprecated(
    'Use ResponsiveBuilder instead. ScalifyBuilder will be removed in v4.0.')
class ScalifyBuilder extends ResponsiveBuilder {
  /// Creates a [ScalifyBuilder] to enable live scaling.
  const ScalifyBuilder({
    super.key,
    required super.builder,
  });
}
