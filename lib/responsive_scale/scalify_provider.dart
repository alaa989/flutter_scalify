import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_scalify/responsive_scale/scalify_config.dart';
import 'responsive_data.dart';
import 'global_responsive.dart';

class ScalifyProvider extends StatefulWidget {
  final Widget child;
  final ScalifyConfig config;

  const ScalifyProvider({
    super.key,
    required this.child,
    this.config = const ScalifyConfig(),
  });

  static ResponsiveData of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_InheritedScalify>();
    if (inherited != null) return inherited.data;
    final mq = MediaQuery.maybeOf(context);
    return ResponsiveData.fromMediaQuery(mq, const ScalifyConfig());
  }

  @override
  State<ScalifyProvider> createState() => _ScalifyProviderState();
}

class _ScalifyProviderState extends State<ScalifyProvider>
    with WidgetsBindingObserver {
  Timer? _debounce;
  ResponsiveData _currentData = ResponsiveData.identity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce =
        Timer(Duration(milliseconds: widget.config.debounceWindowMillis), () {
      if (mounted) _recalculate();
    });
  }

  void _recalculate() {
    final mq = MediaQuery.maybeOf(context);
    final newData = ResponsiveData.fromMediaQuery(mq, widget.config);

    if (newData != _currentData) {
      setState(() {
        _currentData = newData;
      });
      GlobalResponsive.update(newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Optimization #3: Calculate once, use everywhere
    final mq = MediaQuery.maybeOf(context);
    final newData = ResponsiveData.fromMediaQuery(mq, widget.config);

    // Sync global state efficiently
    if (newData != _currentData) {
      _currentData = newData;
      GlobalResponsive.update(newData);
    }

    return _InheritedScalify(
      data: _currentData,
      child: widget.child,
    );
  }
}

class _InheritedScalify extends InheritedWidget {
  final ResponsiveData data;
  const _InheritedScalify({required this.data, required super.child});

  @override
  bool updateShouldNotify(covariant _InheritedScalify oldWidget) {
    // The new operator == in ResponsiveData handles the logic here perfectly
    return data != oldWidget.data;
  }
}