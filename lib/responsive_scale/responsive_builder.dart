import 'package:flutter/material.dart';
import 'package:flutter_scalify/flutter_scalify.dart';


typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context, 
  ResponsiveData data
);

class ResponsiveBuilder extends StatelessWidget {
  final ResponsiveWidgetBuilder builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
  
    return builder(context, context.responsiveData);
  }
}