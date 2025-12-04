import 'package:flutter/material.dart';

class AppWidthLimiter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final Color? backgroundColor;
  final double horizontalPadding;

  const AppWidthLimiter({
    super.key,
    required this.child,
    this.maxWidth = 1000.0,
    this.backgroundColor,
    this.horizontalPadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double screenWidth = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : MediaQuery.maybeOf(context)?.size.width ?? 0.0;

      if (screenWidth > maxWidth) {
        return Container(
          color: backgroundColor,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        );
      }

      return child;
    });
  }
}
