import 'package:flutter/material.dart';

class AppWidthLimiter extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AppWidthLimiter({
    super.key,
    required this.child,
    this.maxWidth = 1000,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        if (screenWidth > maxWidth) {
      
          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          );
        }

     
        return child;
      },
    );
  }
}
