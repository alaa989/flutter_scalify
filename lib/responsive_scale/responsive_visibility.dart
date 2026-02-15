import 'package:flutter/material.dart';
import 'responsive_data.dart';
import 'responsive_extensions.dart';

/// A widget that conditionally shows its [child] based on the current [ScreenType].
class ResponsiveVisibility extends StatelessWidget {
  /// The widget to show if visibility conditions are met.
  final Widget child;

  /// The widget to show if [child] is hidden. Defaults to [SizedBox.shrink].
  final Widget replacement;

  /// A list of [ScreenType] where the [child] should be visible.
  final List<ScreenType>? visibleOn;

  /// A list of [ScreenType] where the [child] should be hidden.
  final List<ScreenType>? hiddenOn;

  /// Creates a [ResponsiveVisibility] widget.
  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.replacement = const SizedBox.shrink(),
    this.visibleOn,
    this.hiddenOn,
  }) : assert(visibleOn == null || hiddenOn == null,
            'Provide either visibleOn or hiddenOn, not both.');

  @override
  Widget build(BuildContext context) {
    final currentDevice = context.responsiveData.screenType;
    bool isVisible = true;

    if (visibleOn != null) {
      isVisible = visibleOn!.contains(currentDevice);
    } else if (hiddenOn != null) {
      isVisible = !hiddenOn!.contains(currentDevice);
    }

    return isVisible ? child : replacement;
  }
}
