import 'package:flutter/material.dart';
import 'package:flutter_scalify/flutter_scalify.dart';


class ResponsiveVisibility extends StatelessWidget {
  final Widget child;
  final Widget replacement;
  final List<ScreenType>? visibleOn;
  final List<ScreenType>? hiddenOn;

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