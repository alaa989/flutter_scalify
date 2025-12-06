import 'dart:async';
import 'package:flutter/material.dart';
import 'responsive_config.dart';
import 'responsive_data.dart';
import 'global_responsive.dart';

class ResponsiveProvider extends StatefulWidget {
  final Widget child;
  final ResponsiveConfig config;

  const ResponsiveProvider({
    super.key,
    required this.child,
    this.config = const ResponsiveConfig(),
  });

  static ResponsiveData of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_InheritedResponsive>();
    if (inherited != null) return inherited.data;
    final mq = MediaQuery.maybeOf(context);
    return ResponsiveData.fromMediaQuery(mq, const ResponsiveConfig());
  }

  @override
  State<ResponsiveProvider> createState() => _ResponsiveProviderState();
}

class _ResponsiveProviderState extends State<ResponsiveProvider>
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

    return _InheritedResponsive(
      data: _currentData,
      child: widget.child,
    );
  }
}

class _InheritedResponsive extends InheritedWidget {
  final ResponsiveData data;
  const _InheritedResponsive({required this.data, required super.child});

  @override
  bool updateShouldNotify(covariant _InheritedResponsive oldWidget) {
    // The new operator == in ResponsiveData handles the logic here perfectly
    return data != oldWidget.data;
  }
}
